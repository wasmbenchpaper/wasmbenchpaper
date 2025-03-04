use std::collections::{HashMap, HashSet};
use std::fmt::Display;
use std::fs;
use std::time::Instant;

type Int = i32;
type VertexId = Int;
type ColourId = Int;

const COLOR_EMPTY: ColourId = 0;

struct MyGlobal {
    vertices: HashMap<VertexId, Box<Vertex>>,
    colours: HashMap<VertexId, Box<ColourId>>,
    dummy_vertex_id: VertexId,
}

impl MyGlobal {
    fn new() -> MyGlobal {
        MyGlobal {
            vertices: HashMap::new(),
            colours: HashMap::new(),
            dummy_vertex_id: 0,
        }
    }
}

struct MyColour {}

impl MyColour {
    fn new(global: &mut MyGlobal, vertex_id: VertexId) -> *mut ColourId {
        // println!("[trace] MyColour::new called");
        if let Some(t1) = global.colours.get_mut(&vertex_id) {
            let v = t1.as_mut();
            let self_ptr: *mut ColourId = &mut *v as *mut ColourId;
            // println!("[trace] MyColour::new end 1 - seen vertex colour");
            return self_ptr;
        }
        let mut colour = Box::new(COLOR_EMPTY);
        let self_ptr: *mut ColourId = &mut *colour as *mut ColourId;
        global.colours.insert(vertex_id, colour);
        // println!("[trace] MyColour::new end 2 - new vertex colour");
        self_ptr
    }
}

struct Vertex {
    id: VertexId,
    next: *mut Vertex,
    prev: *mut Vertex,
    colour: *mut ColourId,
    neighbours: HashSet<*mut Vertex>,
}

fn magic_f(k: Int, n: Int) -> f64 {
    // println!("[trace] magic_f called");
    return (n as f64).powf(1.0 - (1.0 / ((k - 1) as f64))).ceil();
}

fn k_ge_log_n(k: Int, n: Int) -> bool {
    // println!("[trace] k_ge_log_n called");
    let x: i64 = (2 as i64).pow(k as u32);
    x >= (n as i64)
}

impl Vertex {
    fn new(global: &mut MyGlobal, id: VertexId, colour: *mut ColourId) -> (*mut Vertex, bool) {
        // println!("[trace] Vertex::new called");
        if let Some(t1) = global.vertices.get_mut(&id) {
            let v = t1.as_mut();
            let self_ptr: *mut Vertex = &mut *v as *mut Vertex;
            // println!("[trace] Vertex::new end 1 - seen vertex");
            return (self_ptr, true);
        }
        let mut v = Box::new(Vertex {
            id,
            next: std::ptr::null_mut(),
            prev: std::ptr::null_mut(),
            colour,
            neighbours: Default::default(),
        });
        // let self_ptr = Box::into_raw(v);
        let self_ptr: *mut Vertex = &mut *v as *mut Vertex;
        global.vertices.insert(id, v);
        // println!("[trace] Vertex::new end 2 - new vertex");
        (self_ptr, false)
    }
    fn new_dummy(global: &mut MyGlobal) -> *mut Vertex {
        // println!("[trace] Vertex::new_dummy called");
        global.dummy_vertex_id -= 1;
        let (v, _) = Vertex::new(global, global.dummy_vertex_id, std::ptr::null_mut());
        v
    }
    fn degree(&self) -> Int {
        // println!("[trace] Vertex::degree called");
        self.neighbours.len() as Int
    }
    fn sudoku(&mut self, self_ptr: *mut Vertex) {
        // println!("[trace] Vertex::sudoku called");
        unsafe {
            (*(*self).prev).next = self.next;
            if !(*self).next.is_null() {
                (*(*self).next).prev = (*self).prev;
            }
            for &v in (*self).neighbours.iter() {
                (*v).neighbours.remove(&self_ptr);
            }
        }
    }
    fn induce(&mut self, global: &mut MyGlobal, self_ptr: *mut Vertex) -> Graph {
        // println!("[trace] Vertex::induce called");
        let mut induced = Graph::new(global);
        let mut m = HashMap::new();
        graph_explore_recursive(
            global,
            self_ptr,
            &mut induced,
            &mut m,
            Some(&mut self.neighbours),
        );
        induced
    }
}

struct Graph {
    dummy: *mut Vertex,
    size: Int,
}

impl Graph {
    fn new(global: &mut MyGlobal) -> Graph {
        // println!("[trace] Graph::new called");
        Graph {
            dummy: Vertex::new_dummy(global),
            size: 0,
        }
    }
    fn head(&self) -> *mut Vertex {
        // println!("[trace] head called");
        unsafe { (*self.dummy).next }
    }
    fn shift(&mut self, v: *mut Vertex) {
        // println!("[trace] shift called");
        let h: *mut Vertex = self.head();
        if !h.is_null() {
            unsafe {
                (*v).next = h;
                (*v).prev = self.dummy;
                (*h).prev = v;
            }
        }
        unsafe {
            (*self.dummy).next = v;
        }
        self.size += 1;
    }
    fn duplicate(&self, global: &mut MyGlobal) -> Graph {
        // println!("[trace] duplicate called");
        // break_line();
        let mut dup = Graph::new(global);
        let mut m = HashMap::new();
        let mut v = self.head();
        while !v.is_null() {
            // println!("[trace] duplicate while loop calling graph_explore_recursive");
            graph_explore_recursive(global, v, &mut dup, &mut m, None);
            v = unsafe { (*v).next };
        }
        // println!("[trace] duplicate end");
        // break_line();
        dup
    }
    fn social_credit(&mut self, bad: *mut Vertex) {
        // println!("[trace] social_credit called");
        unsafe {
            (*bad).sudoku(bad);
        }
        self.size -= 1;
        for &v in unsafe { (*bad).neighbours.iter() } {
            unsafe {
                v.as_mut().unwrap().sudoku(v);
            }
        }
    }
    fn verify_colouring(&self) -> bool {
        // println!("[trace] verify_colouring called");
        let mut v = self.head();
        while !v.is_null() {
            if unsafe { *(*v).colour == COLOR_EMPTY } {
                return false;
            }
            for &u in unsafe { (*v).neighbours.iter() } {
                if unsafe { *(*v).colour == *(*u).colour } {
                    return false;
                }
            }
            v = unsafe { (*v).next };
        }
        true
    }
    fn find_max_degree_vertex(&self) -> *mut Vertex {
        // println!("[trace] find_max_degree_vertex called");
        let mut d: Int = 0;
        let mut ret: *mut Vertex = std::ptr::null_mut();
        let mut v = self.head();
        while !v.is_null() {
            let e = unsafe { v.as_ref().unwrap().degree() };
            if e > d {
                ret = v;
                d = e;
            }
            v = unsafe { (*v).next };
        }
        ret
    }
    fn colour_2(&mut self, i: Int, j: Int) -> bool {
        // println!("[trace] colour_2 called");
        let mut v = self.head();
        while !v.is_null() {
            if unsafe { *(*v).colour != COLOR_EMPTY } {
                v = unsafe { (*v).next };
                continue;
            }
            if !graph_colour_2_helper_recursive(v, i, j) {
                return false;
            }
            v = unsafe { (*v).next };
        }
        true
    }
    fn colour_b(&mut self, global: &mut MyGlobal, k: Int, iprime: Int) -> Int {
        // println!("[trace] colour_b called");
        // break_line();
        let mut i: Int = iprime;
        if k == 2 {
            if self.colour_2(i, i + 1) {
                return 2;
            }
            return 0;
        }
        let n = self.size;
        if k_ge_log_n(k, n) {
            let mut j = 0;
            let mut v = self.head();
            while !v.is_null() {
                unsafe {
                    *(*v).colour = i + j;
                }
                j += 1;
                v = unsafe { (*v).next };
            }
            return n;
        }
        loop {
            let v = self.find_max_degree_vertex();
            if (unsafe { v.as_ref().unwrap().degree() } as f64) < magic_f(k, n) {
                break;
            }
            let mut h = unsafe { v.as_mut().unwrap().induce(global, v) };
            let j = h.colour_b(global, k - 1, i);
            if j == 0 {
                return 0;
            }
            i += j;
            unsafe {
                *(*v).colour = i;
            }
            self.social_credit(v);
        }
        let mut max_degree = 0;
        let mut max_colour = 0;
        let mut v = self.head();
        while !v.is_null() {
            let mut seen: HashSet<ColourId> = HashSet::new();
            for &e in unsafe { (*v).neighbours.iter() } {
                seen.insert(unsafe { *(*e).colour });
            }
            if max_degree < unsafe { v.as_ref().unwrap().degree() } {
                max_degree = unsafe { v.as_ref().unwrap().degree() };
            }
            let mut j = i;
            loop {
                if !seen.contains(&j) {
                    unsafe {
                        *(*v).colour = j;
                    }
                    if max_colour < j {
                        max_colour = j;
                    }
                    j += 1;
                    break;
                }
                j += 1;
            }
            v = unsafe { (*v).next };
        }
        assert!(max_colour < max_degree + i + 1);
        let ret = max_colour - i + 1;
        let bound: f64 = 2.0 * (k as f64) * magic_f(k, n);
        if (ret as f64) > bound {
            return 0;
        }
        ret
    }
    fn colour_c(&self, global: &mut MyGlobal) -> Int {
        // println!("[trace] colour_c called");
        // break_line();
        let mut i = 1;
        loop {
            // println!("[trace] colour_c loop calling duplicate and colour_b");
            let mut h = self.duplicate(global);
            if h.colour_b(global, 1 << i, 1) != 0 {
                break;
            }
            i += 1;
        }
        let mut l = (1 << (i - 1)) + 1;
        let mut r = 1 << i;
        while l < r {
            let m = (l + r) / 2;
            let mut h = self.duplicate(global);
            if h.colour_b(global, m, 1) == 0 {
                l = m + 1;
            } else {
                r = m;
            }
        }
        let mut h = self.duplicate(global);
        let k = h.colour_b(global, l, 1);
        assert!(k != 0);
        k
    }
}

impl Display for Graph {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        // println!("[trace] Display for Graph::fmt called");
        let mut s = String::new();
        let mut v = self.head();
        while !v.is_null() {
            let mut ns: Vec<VertexId> = unsafe {
                v.as_ref()
                    .unwrap()
                    .neighbours
                    .iter()
                    .map(|&x| (*x).id)
                    .collect()
            };
            ns.sort();
            s.push_str(
                format!(
                    "vertex id: {} with color {} is connected to:\n\t{:?}\n",
                    unsafe { (*v).id },
                    unsafe { *(*v).colour },
                    ns,
                )
                .as_str(),
            );
            v = unsafe { (*v).next };
        }
        write!(f, "{}", s)
    }
}

fn graph_explore_recursive(
    global: &mut MyGlobal,
    start: *mut Vertex,
    g: &mut Graph,
    m: &mut HashMap<*mut Vertex, *mut Vertex>,
    valid: Option<&HashSet<*mut Vertex>>,
) -> *mut Vertex {
    // println!(
    //     "[trace] graph_explore_recursive called with start {:?}",
    //     start
    // );
    // short_break_line();
    let new_vertex = match m.get(&start) {
        Some(&v) => {
            return v;
        }
        None => {
            let xx = Vertex::new_dummy(global);
            // println!("[trace] graph_explore_recursive before setting xx.colour to the same pointer as start.colour");
            // println!("[debug] xx {:?} start {:?}", xx, start);
            unsafe { (*xx).colour = (*start).colour };
            xx
        }
    };
    // println!("[trace] graph_explore_recursive before setting colour of new vertex to 0");
    unsafe {
        *(*new_vertex).colour = COLOR_EMPTY;
    }
    // println!("[trace] graph_explore_recursive before inserting start and new_vertex into m");
    m.insert(start, new_vertex);
    // unsafe {
    //     let debug_t1: Vec<&*mut Vertex> = (*start).neighbours.iter().collect();
    //     println!(
    //         "[trace] graph_explore_recursive before looping over the neighbours {:?}",
    //         debug_t1
    //     );
    // }
    for &v in unsafe { (*start).neighbours.iter() } {
        // println!("[trace] graph_explore_recursive loop over neighbours checking valid");
        if valid.is_some() && !valid.unwrap().contains(&v) {
            continue;
        }
        // println!(
        //     "[trace] graph_explore_recursive loop over neighbours calling graph_explore_recursive with start {:?}", v
        // );
        let neighbour = graph_explore_recursive(global, v, g, m, valid);
        unsafe {
            (*new_vertex).neighbours.insert(neighbour);
        }
    }
    g.shift(new_vertex);
    new_vertex
}

fn graph_colour_2_helper_recursive(v: *mut Vertex, i: Int, j: Int) -> bool {
    // println!("[trace] graph_colour_2_helper_recursive called");
    if unsafe { *(*v).colour == j } {
        return false;
    }
    if unsafe { *(*v).colour == COLOR_EMPTY } {
        unsafe {
            *(*v).colour = i;
        }
        for &u in unsafe { (*v).neighbours.iter() } {
            if !graph_colour_2_helper_recursive(u, j, i) {
                return false;
            }
        }
    }
    return true;
}

fn graph_from_file(global: &mut MyGlobal, input_txt: String) -> Graph {
    // println!("[trace] graph_from_file called");
    let mut graph = Graph::new(global);
    for line in input_txt.lines() {
        if line.starts_with("#") {
            continue;
        }
        let parts: Vec<&str> = line.split("\t").collect();
        if parts.len() != 2 {
            println!("invalid line, skipping: '{}'", line);
            continue;
        }
        let left_vertex_id: Int = match parts[0].parse() {
            Ok(x) => x,
            Err(e) => {
                println!(
                    "failed to parse the id '{}' as an integer. error: {}",
                    parts[0], e
                );
                continue;
            }
        };
        let right_vertex_id: Int = match parts[1].parse() {
            Ok(x) => x,
            Err(e) => {
                println!(
                    "failed to parse the id '{}' as an integer. error: {}",
                    parts[1], e
                );
                continue;
            }
        };

        // println!(
        //     "[debug] left_vertex_id {} right_vertex_id {}",
        //     left_vertex_id, right_vertex_id
        // );
        unsafe {
            let left_colour = MyColour::new(global, left_vertex_id);
            let right_colour = MyColour::new(global, right_vertex_id);
            // println!(
            //     "[debug] left_colour {:?} right_colour {:?}",
            //     left_colour, right_colour
            // );
            let (left_vertex, left_ok) = Vertex::new(global, left_vertex_id, left_colour);
            let (right_vertex, right_ok) = Vertex::new(global, right_vertex_id, right_colour);
            (*left_vertex).neighbours.insert(right_vertex);
            (*right_vertex).neighbours.insert(left_vertex);
            if !left_ok {
                graph.shift(left_vertex);
            }
            if !right_ok {
                graph.shift(right_vertex);
            }
        }
    }
    graph
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    if args.len() != 2 {
        println!("usage: graph-recursive <path/to/graph/file>");
        std::process::exit(1);
    }
    // println!("got the args {:?}", args);
    let input_path = args[1].to_owned();
    // println!("reading the file at path '{}'", input_path);
    // let start_instant = Instant::now();
    // let t0 = start_instant.elapsed().as_nanos();
    let input_txt = match fs::read_to_string(&input_path) {
        Ok(x) => x,
        Err(e) => {
            println!(
                "failed to read the file at path '{}' . error: {}",
                input_path, e
            );
            std::process::exit(1);
        }
    };
    // let t1 = start_instant.elapsed().as_nanos();
    // println!("contents of the file:\n{}", input_txt);
    // println!("[info] read file: {} ns", t1 - t0);
    let mut global = MyGlobal::new();
    let graph = graph_from_file(&mut global, input_txt);
    // let t2 = start_instant.elapsed().as_nanos();
    // println!("created the graph:\n{}", graph);
    // println!("[info] created the graph: {} ns", t2 - t1);
    // break_line();
    let k = graph.colour_c(&mut global);
    // let t3 = start_instant.elapsed().as_nanos();
    // println!("[info] colored the graph: {} ns", t3 - t2);
    // println!("k = {}", k);
    // println!("the colored graph:\n{}", graph);
    assert!(graph.verify_colouring());
}

// fn break_line() {
//     println!("------------------------------------------");
// }

// fn short_break_line() {
//     println!("---------------------");
// }
