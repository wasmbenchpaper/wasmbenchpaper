import argparse
import json
import os
import re
import subprocess
from pathlib import Path
from typing import Dict, List, Tuple

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from matplotlib.ticker import MaxNLocator
from tqdm import tqdm

# from tqdm.notebook import tqdm

DEFAULT_FLAMEGRAPH_SCRIPTS_LOCATION = (
    "/root/code/remote/github.com/brendangregg/FlameGraph"
)


def parse_time_txt(s: str):
    time_txt_regex = re.compile(
        r"^(?P<type>real|user|sys)\s+(?P<minutes>\d+)m(?P<seconds>\d+(?:\.\d+)?)s$"
    )
    lines = s.split("\n")
    for line in lines:
        if line.strip() == "":
            continue
        m = time_txt_regex.match(line)
        if not m:
            continue
        time_type = m.group("type")
        time_minutes = float(m.group("minutes"))
        time_seconds = float(m.group("seconds"))
        time_total_seconds = time_minutes * 60 + time_seconds
        print(line)
        print(time_type, time_minutes, time_seconds, time_total_seconds)


def test_parse_time_txt(input_path: str) -> None:
    with open(input_path) as f:
        print(parse_time_txt(f.read()))


def get_dict_keys_values(d: Dict) -> Tuple[List, List]:
    keys = list(d.keys())
    values = [d[k] for k in keys]
    return keys, values


def get_sorted_xs_ys(xs: List[str], ys: List) -> Tuple[List, List]:
    idxs = list(range(len(xs)))
    # print(idxs, xs, ys)
    sorted_idxs = sorted(idxs, key=lambda i: (len(xs[i]), xs[i]))
    sorted_xs = [xs[i] for i in sorted_idxs]
    sorted_ys = [ys[i] for i in sorted_idxs]
    return sorted_xs, sorted_ys


def plot_bar_chart(
    _xs,
    _ys,
    output_path=None,
    title=None,
    figsize=None,
    print_path=True,
    xlabel=None,
    ylabel=None,
):
    plt.cla()
    plt.close()
    all_integers = all(isinstance(y, int) for y in _ys)
    xs, ys = get_sorted_xs_ys(_xs, _ys)
    fig, ax = plt.subplots(figsize=figsize) if figsize is not None else plt.subplots()
    ax.ticklabel_format(style="plain")
    if all_integers:
        ax.yaxis.set_major_locator(MaxNLocator(integer=True))
    if title is not None:
        ax.set_title(title)
    if xlabel:
        ax.set_xlabel(xlabel)
    if ylabel:
        ax.set_ylabel(ylabel)
    # ax.tick_params(axis='x', which='major', labelsize=15)
    # ax.tick_params(axis='both', which='major', pad=15)
    ax.set_xticks(range(len(xs)))
    ax.set_xticklabels(xs, rotation="vertical")
    ax.bar(xs, ys)
    if output_path is None:
        return fig
    if print_path:
        print(f"saving the figure to: {output_path}")
    fig.savefig(output_path, dpi=300, bbox_inches="tight")
    plt.close(fig)


def get_workload_and_lang(workload_name: str) -> Tuple[str, str]:
    languages = ["c", "go", "py", "rust"]
    workloads = ["sort", "copyfile", "sudoku", "graph", "fileserver", "without", "simd"]

    curr_lang = None
    for l in languages:
        if "-" + l + "-" in workload_name or workload_name.startswith(l + "-"):
            curr_lang = l
            break
    curr_work = None
    for w in workloads:
        if (
            "-" + w + "-" in workload_name
            or workload_name.startswith(w + "-")
            or workload_name.endswith("-" + w)
        ):
            curr_work = w
            break
    return curr_work, curr_lang


def get_loads_and_stores(input_path: str) -> Tuple[int, int]:
    with open(input_path) as f:
        data = f.read()
    lines = data.split("\n")
    words = [line.split() for line in lines if len(line) > 0]
    counts = [(line_words[4], int(line_words[3], base=10)) for line_words in words]
    loads = 0
    stores = 0
    for x, c in counts:
        if x == "cpu/mem-loads,ldlat=30/P:":
            loads += c
        elif x == "cpu/mem-stores/P:":
            stores += c
        else:
            assert False, f"bad key (not a load or store). actual: {x}"
    return loads, stores


def test_utils() -> None:
    """Tests for utility functions."""
    xs = [
        "runsc-sdk-wrapper-rust-sort-time",
        "runsc-sdk-wrapper-c-copyfile-time",
        "runsc-sdk-wrapper-go-copyfile-time",
        "runsc-sdk-wrapper-go-sort-time",
        "runsc-sdk-wrapper-py-copyfile-time",
        "runsc-sdk-wrapper-c-sort-time",
        "runsc-sdk-wrapper-rust-copyfile-time",
        "runsc-sdk-wrapper-py-sort-time",
        "without-rust-simd",
        "py-copyfile",
        "without-c-simd",
        "py-sort",
        "go-sort",
        "py-graph",
        "c-copyfile",
        "go-copyfile",
        "c-fileserver",
        "rust-sudoku",
        "py-simd",
        "go-sudoku",
        "go-graph",
        "c-sudoku",
        "without-go-simd",
        "c-simd",
        "rust-graph",
        "without-py-simd",
        "rust-simd",
        "native-c-fileserver",
        "c-sort",
        "c-graph",
        "rust-fileserver",
        "rust-copyfile",
        "rust-sort",
        "py-sudoku",
        "crun-plain-sdk-wrapper-c-sort-time",
        "crun-plain-sdk-wrapper-go-sort-time",
        "crun-plain-sdk-wrapper-c-copyfile-time",
        "crun-plain-sdk-wrapper-go-copyfile-time",
        "crun-plain-sdk-wrapper-rust-copyfile-time",
        "crun-plain-sdk-wrapper-py-copyfile-time",
        "crun-plain-sdk-wrapper-rust-sort-time",
        "crun-plain-sdk-wrapper-py-sort-time",
        "wasm-rust-graph",
        "wasm-go-graph",
        "wasm-rust-copyfile",
        "wasm-py-graph",
        "wasm-c-graph",
        "wasm-go-sudoku",
        "wasm-rust-sudoku",
        "wasm-py-sort",
        "wasm-go-copyfile",
        "wasm-go-sort",
        "wasm-c-copyfile",
        "wasm-py-copyfile",
        "wasm-rust-sort",
        "wasm-c-sort",
        "wasm-c-sudoku",
        "wasm-py-sudoku",
        "py-copyfile",
        "py-sort",
        "go-sort",
        "c-copyfile",
        "go-copyfile",
        "c-sort",
        "rust-copyfile",
        "rust-sort",
        "native-c-copyfile-runsc",
        "native-rust-simd-runsc",
        "native-rust-sort-runsc",
        "native-rust-simd-runsc-without",
        "native-go-graph-runsc",
        "native-py-copyfile-runsc",
        "native-rust-sudoku-runsc",
        "native-py-graph-runsc",
        "native-c-sort-runsc",
        "native-c-graph-runsc",
        "native-c-simd-runsc",
        "native-go-sort-runsc",
        "native-go-simd-runsc-without",
        "native-c-simd-runsc-without",
        "native-py-sort-runsc",
        "native-rust-copyfile-runsc",
        "native-c-sudoku-runsc",
        "native-rust-graph-runsc",
        "native-go-copyfile-runsc",
        "native-go-sudoku-runsc",
        "container-wasm-go-graph-crun-wasmtime",
        "container-wasm-go-copyfile-crun-wasmtime",
        "container-wasm-go-sudoku-crun-wasmtime",
        "container-wasm-rust-simd-crun-wasmtime",
        "container-wasm-go-simd-crun-wasmtime-without",
        "container-wasm-rust-graph-crun-wasmtime",
        "container-wasm-c-copyfile-crun-wasmtime",
        "container-wasm-c-simd-crun-wasmtime",
        "container-wasm-py-copyfile-crun-wasmtime",
        "container-wasm-py-sudoku-crun-wasmtime",
        "container-wasm-c-simd-crun-wasmtime-without",
        "container-wasm-c-sort-crun-wasmtime",
        "container-wasm-rust-simd-crun-wasmtime-without",
        "container-wasm-c-sudoku-crun-wasmtime",
        "container-wasm-rust-copyfile-crun-wasmtime",
        "container-wasm-go-sort-crun-wasmtime",
        "container-wasm-py-sort-crun-wasmtime",
        "container-wasm-rust-sort-crun-wasmtime",
        "container-wasm-rust-sudoku-crun-wasmtime",
        "container-wasm-py-graph-crun-wasmtime",
        "container-wasm-c-graph-crun-wasmtime",
        "native-rust-sort-crun-plain",
        "native-go-copyfile-crun-plain",
        "native-go-sort-crun-plain",
        "native-c-sort-crun-plain",
        "native-rust-sudoku-crun-plain",
        "native-c-copyfile-crun-plain",
        "native-py-graph-crun-plain",
        "native-c-graph-crun-plain",
        "native-c-fileserver-crun-plain",
        "native-go-simd-crun-plain-without",
        "native-rust-graph-crun-plain",
        "native-c-simd-crun-plain-without",
        "native-go-graph-crun-plain",
        "native-go-sudoku-crun-plain",
        "native-rust-copyfile-crun-plain",
        "native-c-simd-crun-plain",
        "native-py-copyfile-crun-plain",
        "native-c-sudoku-crun-plain",
        "native-rust-simd-crun-plain-without",
        "native-rust-simd-crun-plain",
        "native-py-sort-crun-plain",
    ]

    ys = [(x, get_workload_and_lang(x)) for x in xs]
    for y in ys:
        print(y)
    print(
        get_sorted_xs_ys(
            [
                "crun_native",
                "crun_sdk",
                "crun_wasm",
                "gvisor_native",
                "gvisor_sdk",
                "native",
                "sdk",
                "wasm",
            ],
            [8, 7, 4, 5, 6, 1, 3, 2],
        )
    )
    print(
        get_dict_keys_values(
            {
                "b": 2,
                "c": 4,
                "bar": 3,
                "a": 1,
            }
        )
    )
    if Path("./perfmemrecord").is_file():
        print("loads and stores", get_loads_and_stores("./perfmemrecord"))
    if Path("./time.txt").is_file():
        print("test_parse_time_txt", test_parse_time_txt("./time.txt"))
    if Path("./collected_times.txt").is_file():
        print("test_parse_time_txt", test_parse_time_txt("./collected_times.txt"))


def collect_data_into_json(
    input_dir: str,
    output_dir: str = "output_iter_1",
    run_perf: bool = False,
    flamegraph_scripts_dir: str = DEFAULT_FLAMEGRAPH_SCRIPTS_LOCATION,
) -> Path:
    platform_lang_workload_perf_data = dict()
    seen_syscalls = set()
    relevant_lines_regex = re.compile(r"^\s+(?P<count>\d+)\s+(?P<tag>[\w-]+)\s+#")
    relevant_lines_time_regex = re.compile(
        r"^\s+(?P<time>\d+(?:\.\d+)?) seconds (?P<tag>time elapsed|user|sys)$"
    )
    relevant_lines_task_clock_regex = re.compile(
        r"^\s+(?P<time>\d+(?:\.\d+)?) msec task-clock\s+#"
    )
    time_txt_regex = re.compile(
        r"^(?P<type>real|user|sys)\s+(?P<minutes>\d+)m(?P<seconds>\d+(?:\.\d+)?)s$"
    )

    failed_perf_stats = []
    # 487.22,msec,task-clock,487215603,100.00,0.243,CPUs utilized
    perf_stat_column_names = [
        "value",
        "value-unit",
        "key",
        "value-2",
        "percent",
        "value-3",
        "details",
    ]

    platforms = sorted(os.listdir(input_dir), key=lambda s: (len(s), s))
    for platform in (pbar_platform := tqdm(platforms, desc="platforms")):
        pbar_platform.set_description(f"platform: {platform}")
        # print(f'{"#"*32} platform {platform} {"#"*32}')
        platform_dir = os.path.join(input_dir, platform)
        # print('platform_dir', platform_dir)
        langs = sorted(os.listdir(platform_dir))
        if platform not in platform_lang_workload_perf_data:
            platform_lang_workload_perf_data[platform] = dict()
        for lang in (pbar_lang := tqdm(langs, desc="langs", leave=False)):
            pbar_lang.set_description(f"lang: {lang}")
            # print(f'{"="*32} lang {lang} {"="*32}')
            lang_dir = os.path.join(platform_dir, lang)
            # print('lang_dir', lang_dir)
            workloads = sorted(os.listdir(lang_dir))
            if lang not in platform_lang_workload_perf_data[platform]:
                platform_lang_workload_perf_data[platform][lang] = dict()
            for workload in (
                pbar_workload := tqdm(workloads, desc="workloads", leave=False)
            ):
                pbar_workload.set_description(f"workload: {workload}")
                # print(f'{"-"*32} workload {workload} {"-"*32}')
                workload_dir = os.path.join(lang_dir, workload)
                # print('workload_dir', workload_dir)
                perf_types = sorted(os.listdir(workload_dir))
                if workload not in platform_lang_workload_perf_data[platform][lang]:
                    platform_lang_workload_perf_data[platform][lang][workload] = dict()
                if run_perf:
                    os.makedirs(os.path.join(workload_dir, "reports"), exist_ok=True)
                for perf_type in (
                    pbar_perftype := tqdm(perf_types, desc="perf_types", leave=False)
                ):
                    pbar_perftype.set_description(f"perf_type: {perf_type}")
                    # print('perf_type', perf_type)
                    perf_path = os.path.join(workload_dir, perf_type)
                    # print('perf_path', perf_path)
                    if (
                        perf_type == "perfrecord"
                        or perf_type == "perfmemrecord"
                        or perf_type == "perfmemrecordF"
                    ):
                        if not run_perf:
                            continue
                        # print('run perf report')
                        perf_script_path = os.path.join(
                            workload_dir, "reports", perf_type
                        )
                        with open(perf_script_path, "w") as f:
                            # subprocess.run(['echo', 'perf', 'script', '-i', perf_path], stdout=f)
                            subprocess.run(
                                ["perf", "script", "-i", perf_path], stdout=f
                            )
                        if perf_type == "perfmemrecordF":
                            perf_folded_path = os.path.join(
                                workload_dir, "reports", perf_type + ".folded"
                            )
                            with open(perf_folded_path, "w") as f:
                                subprocess.run(
                                    [
                                        os.path.join(
                                            flamegraph_scripts_dir,
                                            "stackcollapse-perf.pl",
                                        ),
                                        perf_script_path,
                                    ],
                                    stdout=f,
                                )
                            perf_svg_path = os.path.join(
                                workload_dir, "reports", perf_type + ".svg"
                            )
                            with open(perf_svg_path, "w") as f:
                                subprocess.run(
                                    [
                                        os.path.join(
                                            flamegraph_scripts_dir, "flamegraph.pl"
                                        ),
                                        perf_folded_path,
                                    ],
                                    stdout=f,
                                )
                            # print('perf_folded_path', perf_folded_path, 'perf_svg_path', perf_svg_path)
                        continue
                    if perf_type.startswith("perfstat"):
                        # print('perfstat logs')
                        with open(perf_path) as f:
                            perf_stat_data = f.read().strip()
                        # print('perf_stat_data', perf_stat_data)
                        if perf_stat_data == "":
                            # print('empty perf stat file')
                            continue
                        perf_stat_data_lines = perf_stat_data.split("\n")
                        detect_line = perf_stat_data_lines[3]
                        # print('detect_line', detect_line)
                        if not detect_line.startswith(" Performance counter stats for"):
                            # print('!'*64)
                            # print('bad perf stat file, detect_line:', detect_line)
                            # print('perf_stat_data_lines[2]', perf_stat_data_lines[2])
                            task_clock_line = perf_stat_data_lines[2].split(",")
                            assert (
                                task_clock_line[2] == "task-clock"
                            ), f"expected task clock. actual: {task_clock_line[2]}"
                            task_clock_ms = float(task_clock_line[0])
                            # print('task_clock_line', task_clock_line, 'task_clock_ms', task_clock_ms)
                            platform_lang_workload_perf_data[platform][lang][workload][
                                "task-clock-ms"
                            ] = task_clock_ms
                            # print('!'*64)
                            failed_perf_stats.append(perf_path)
                            # print('attempt to parse csv:', perf_path)
                            with open(perf_path) as f:
                                # print(perf_stat_data)
                                df = pd.read_csv(
                                    f, skiprows=3, names=perf_stat_column_names
                                )
                                # print(df)
                                # print(df['key'].values)
                                # print(df['value'].values)
                                for k, v in zip(
                                    df["key"].values.tolist(),
                                    df["value"].values.tolist(),
                                ):
                                    # print(type(k), type(int(v)), k, int(v))
                                    try:
                                        # print(type(k), type(v), k, v)
                                        count = (
                                            v if isinstance(v, int) else int(v, base=10)
                                        )
                                        platform_lang_workload_perf_data[platform][
                                            lang
                                        ][workload][k] = count
                                    except Exception as e:
                                        print(
                                            f"failed to convert value to int. path: {perf_path} value: {type(v)} {v} error: {e}"
                                        )
                            continue
                        #############################################################################################
                        f_data_relevant_task_clock_line = perf_stat_data_lines[5]
                        f_data_relevant_lines = perf_stat_data_lines[6 : 6 + 11]
                        f_data_relevant_time_lines = perf_stat_data_lines[
                            6 + 12 : 6 + 12 + 4
                        ]
                        # print(
                        #     'f_data_relevant_task_clock_line', f_data_relevant_task_clock_line,
                        #     'f_data_relevant_lines', f_data_relevant_lines,
                        #     'f_data_relevant_time_lines', f_data_relevant_time_lines,
                        # )
                        task_clock_match = relevant_lines_task_clock_regex.match(
                            f_data_relevant_task_clock_line
                        )
                        if task_clock_match:
                            task_clock_ms = float(
                                task_clock_match.group("time")
                            )  # milliseconds
                            # print('task_clock_ms', task_clock_ms)
                            platform_lang_workload_perf_data[platform][lang][workload][
                                "task-clock-ms"
                            ] = task_clock_ms
                        for line in f_data_relevant_lines:
                            m = relevant_lines_regex.match(line)
                            if not bool(m):
                                continue
                            perf_counter = m.group("tag")
                            actual_count = int(m.group("count"), base=10)
                            # print('perf_counter', perf_counter, 'actual_count', actual_count)
                            platform_lang_workload_perf_data[platform][lang][workload][
                                perf_counter
                            ] = actual_count
                        for line in f_data_relevant_time_lines:
                            m = relevant_lines_time_regex.match(line)
                            if not bool(m):
                                continue
                            time_type = m.group("tag")
                            perf_counter_key = (
                                "time-elapsed"
                                if time_type == "time elapsed"
                                else "time-" + time_type
                            )
                            time_elapsed = float(m.group("time"))  # seconds
                            platform_lang_workload_perf_data[platform][lang][workload][
                                perf_counter_key
                            ] = time_elapsed
                        #############################################################################################
                        continue
                    if perf_type == "reports":
                        # print('found a reports dir')
                        reports = sorted(os.listdir(perf_path))
                        for report in reports:
                            # print('report', report)
                            report_path = os.path.join(perf_path, report)
                            # print('report_path', report_path)
                            if report != "perfmemrecord":
                                continue
                            # print('get loads and stores from mem record')
                            loads, stores = get_loads_and_stores(report_path)
                            # print('loads, stores', loads, stores, type(loads), type(stores))
                            platform_lang_workload_perf_data[platform][lang][workload][
                                "mem-loads"
                            ] = loads
                            platform_lang_workload_perf_data[platform][lang][workload][
                                "mem-stores"
                            ] = stores
                            # with open(report_path) as f:
                            #     report_path_data = f.read()
                            # print(report_path_data[:200])
                        continue
                    if perf_type != "logs":
                        # print('not a logs dir')
                        continue
                    # print('logs dir')
                    logs = sorted(os.listdir(perf_path))
                    for log in logs:
                        # print('log', log)
                        log_path = os.path.join(perf_path, log)
                        # print('log_path', log_path)
                        if log.startswith("time.txt"):
                            with open(log_path) as f:
                                time_txt_data = f.read()
                            lines = time_txt_data.split("\n")
                            for line in lines:
                                if line.strip() == "":
                                    continue
                                m = time_txt_regex.match(line)
                                if not m:
                                    continue
                                time_type = m.group("type")
                                time_minutes = float(m.group("minutes"))
                                time_seconds = float(m.group("seconds"))
                                time_total_seconds = time_minutes * 60 + time_seconds
                                # print(line)
                                # print(time_type, time_minutes, time_seconds, time_total_seconds)
                                platform_lang_workload_perf_data[platform][lang][
                                    workload
                                ]["time-txt-" + time_type] = time_total_seconds
                        if log.startswith("syscount"):
                            # print('syscount logs')
                            if (
                                "syscount"
                                not in platform_lang_workload_perf_data[platform][lang][
                                    workload
                                ]
                            ):
                                platform_lang_workload_perf_data[platform][lang][
                                    workload
                                ]["syscount"] = dict()
                            syscount_table = pd.read_csv(
                                log_path, skiprows=1, sep=r"\s+"
                            )
                            # print('syscount_table', syscount_table)
                            syscount_table_records = syscount_table.to_dict(
                                orient="records"
                            )
                            # print('syscount_table_records', syscount_table_records)
                            for kv in syscount_table_records:
                                seen_syscalls.add(kv["SYSCALL"])
                                platform_lang_workload_perf_data[platform][lang][
                                    workload
                                ]["syscount"][kv["SYSCALL"]] = kv["COUNT"]
                            continue
                # print('-'*64)
            # print('='*64)
        # print('#'*64)
    os.makedirs(output_dir, exist_ok=True)
    # print('failed_perf_stats', failed_perf_stats)
    with open(os.path.join(output_dir, "failed_perf_stats.json"), "w") as f:
        json.dump(failed_perf_stats, f)
    # print('seen_syscalls', seen_syscalls)
    with open(os.path.join(output_dir, "seen_syscalls.json"), "w") as f:
        json.dump(list(seen_syscalls), f)
    # print('platform_lang_workload_perf_data', platform_lang_workload_perf_data)
    perf_data_path = Path(output_dir) / "perf_data.json"
    with open(perf_data_path, "w") as f:
        json.dump(platform_lang_workload_perf_data, f)
    return perf_data_path


def copy_flame_graphs(
    paths_file: str = "flame_paths.txt", output_dir: str = "output_results_3"
) -> None:
    with open(paths_file) as f:
        lines = [line for line in f.read().split("\n") if len(line) > 0]
    print("num flamegraphs:", len(lines))
    os.makedirs(os.path.join(output_dir, "flamegraphs"), exist_ok=True)
    for line in tqdm(lines):
        t1 = "-".join(line.split("/")[3:-2]) + "-flamegraph.svg"
        dst_path = os.path.join(output_dir, "flamegraphs", t1)
        with open(line) as src, open(dst_path, "w") as dst:
            dst.write(src.read())


# def plot_graphs(data_path, output_dir="output_iter_1"):
def plot_graphs(data_path: str, output_dir: str) -> None:
    print(f"plot_graphs called with data_path: {data_path} output_dir: {output_dir}")
    with open(data_path, "r", encoding="utf-8") as f:
        data = json.load(f)
    # print('data', data)
    workload_vs_total_syscalls = dict()
    perf_counters_vs_workload_vs_platform_lang = dict()
    workload_vs_min_time = dict()
    workload_vs_max_time = dict()
    workload_vs_avg_time = dict()
    workload_vs_times = dict()
    for platform in data:
        # print('platform', platform)
        for lang in data[platform]:
            # print('lang', lang)
            for workload in data[platform][lang]:
                # print('workload', workload)
                # print('platform', platform, 'lang', lang, 'workload', workload)
                for k in data[platform][lang][workload]:
                    # print(k, data[platform][lang][workload][k])
                    platform_lang = platform + "-" + lang
                    # if k == 'time-elapsed':
                    if k == "time-txt-real":
                        curr_time = data[platform][lang][workload][k]
                        # print('curr_time', curr_time)
                        if workload in workload_vs_min_time:
                            name, curr_min_time = workload_vs_min_time[workload]
                            if curr_time < curr_min_time:
                                workload_vs_min_time[workload] = (
                                    platform_lang,
                                    curr_time,
                                )
                        else:
                            workload_vs_min_time[workload] = (platform_lang, curr_time)
                        if workload in workload_vs_max_time:
                            name, curr_max_time = workload_vs_max_time[workload]
                            if curr_time > curr_max_time:
                                workload_vs_max_time[workload] = (
                                    platform_lang,
                                    curr_time,
                                )
                        else:
                            workload_vs_max_time[workload] = (platform_lang, curr_time)
                        if workload in workload_vs_avg_time:
                            total, n, _ = workload_vs_avg_time[workload]
                            workload_vs_avg_time[workload] = (
                                total + curr_time,
                                n + 1,
                                (total + curr_time) / (n + 1),
                            )
                        else:
                            workload_vs_avg_time[workload] = (curr_time, 1, curr_time)
                        if workload not in workload_vs_times:
                            workload_vs_times[workload] = []
                        workload_vs_times[workload].append(curr_time)
                    if k == "syscount":
                        if workload not in workload_vs_total_syscalls:
                            workload_vs_total_syscalls[workload] = dict()
                        if platform_lang not in workload_vs_total_syscalls[workload]:
                            workload_vs_total_syscalls[workload][platform_lang] = dict()
                        syscounts = data[platform][lang][workload][k]
                        total_syscount = sum(syscounts.values())
                        workload_vs_total_syscalls[workload][
                            platform_lang
                        ] = total_syscount
                        continue
                    if k not in perf_counters_vs_workload_vs_platform_lang:
                        perf_counters_vs_workload_vs_platform_lang[k] = dict()
                    if workload not in perf_counters_vs_workload_vs_platform_lang[k]:
                        perf_counters_vs_workload_vs_platform_lang[k][workload] = dict()
                    perf_counters_vs_workload_vs_platform_lang[k][workload][
                        platform_lang
                    ] = data[platform][lang][workload][k]

    print("workload_vs_min_time", workload_vs_min_time)
    print("workload_vs_max_time", workload_vs_max_time)
    print("workload_vs_avg_time", workload_vs_avg_time)
    # print('workload_vs_times', workload_vs_times)
    workload_vs_median_time = dict()
    for w in workload_vs_times:
        med = np.median(workload_vs_times[w])
        workload_vs_median_time[w] = med
        # print(
        #     'workload', w,
        #     'median time', med,
        #     'times', workload_vs_times[w],
        # )
    print("workload_vs_median_time", workload_vs_median_time)
    os.makedirs(os.path.join(output_dir, "syscall_counts"), exist_ok=True)
    with open(os.path.join(output_dir, "time.json"), "w") as f:
        json.dump(
            {
                "workload_vs_min_time": workload_vs_min_time,
                "workload_vs_max_time": workload_vs_max_time,
                "workload_vs_median_time": workload_vs_median_time,
                "workload_vs_avg_time": workload_vs_avg_time,
                "workload_vs_times": workload_vs_times,
            },
            f,
        )
    for workload in (pbar := tqdm(workload_vs_total_syscalls)):
        pbar.set_description(f"total syscall count for workload: {workload}")
        # print('plot syscall graph for workload', workload)
        xs, ys = get_dict_keys_values(workload_vs_total_syscalls[workload])
        plot_bar_chart(
            xs,
            ys,
            output_path=os.path.join(output_dir, "syscall_counts", workload + ".svg"),
            title=workload,
            xlabel="platform and language",
            ylabel="total number of syscalls",
            print_path=False,
        )
    for perf_counter in (pbar := tqdm(perf_counters_vs_workload_vs_platform_lang)):
        pbar.set_description(f"perf_counter: {perf_counter}")
        os.makedirs(os.path.join(output_dir, perf_counter), exist_ok=True)
        for workload in (
            pbar_perf := tqdm(
                perf_counters_vs_workload_vs_platform_lang[perf_counter], leave=False
            )
        ):
            pbar_perf.set_description(f"workload: {workload}")
            # print('plot graph for perf_counter', perf_counter, 'for workload', workload)
            xs, ys = get_dict_keys_values(
                perf_counters_vs_workload_vs_platform_lang[perf_counter][workload]
            )
            ylabel = perf_counter.replace("-", " ")
            if perf_counter == "time-txt-real":
                ylabel = "execution time (in seconds)"
            elif perf_counter == "time-txt-sys":
                ylabel = "execution system time (in seconds)"
            elif perf_counter == "time-txt-user":
                ylabel = "execution user time (in seconds)"
            plot_bar_chart(
                xs,
                ys,
                output_path=os.path.join(output_dir, perf_counter, workload + ".svg"),
                title=workload,
                xlabel="platform and language",
                ylabel=ylabel,
                print_path=False,
            )
    os.makedirs(os.path.join(output_dir, "peaks"), exist_ok=True)
    for workload in (pbar := tqdm(workload_vs_max_time)):
        pbar.set_description(f"workload: {workload}")
        platform_lang, max_time = workload_vs_max_time[workload]
        t1idx = platform_lang.rfind("-")
        platform, lang = platform_lang[:t1idx], platform_lang[t1idx + 1 :]
        language = "python" if lang == "py" else lang
        # print("workload:", workload, platform, lang, max_time)
        syscall_dist = data[platform][lang][workload]["syscount"]
        # print('syscall_dist', syscall_dist)
        xs, ys = get_dict_keys_values(syscall_dist)
        plot_bar_chart(
            xs,
            ys,
            output_path=os.path.join(
                output_dir,
                "peaks",
                workload + "-" + platform_lang + "-syscall-dist.svg",
            ),
            figsize=(25, 5),
            title=f"syscall distribution for workload {workload} on platform {platform} and language {lang}",
            xlabel="syscall",
            ylabel="count",
            print_path=False,
        )

        # commenting this out
        # try:
        #     t11 = f"{platform}-{lang}-{workload}-flamegraph.svg"
        #     with open(
        #         # os.path.join(output_dir, 'flamegraphs', f'{platform}-{lang}-{workload}-reports-perfmemrecordF.svg'),
        #         os.path.join(output_dir, "flamegraphs", t11),
        #     ) as src, open(
        #         os.path.join(output_dir, "peaks", t11),
        #         "w",
        #     ) as dst:
        #         # print(f'copy the flamegraph for {platform} {lang} {workload}')
        #         dst.write(src.read())
        # except Exception as e:
        #     print(
        #         f"failed to copy the flamegraph for {platform} {lang} {workload} . error: {e}"
        #     )
        # commenting this out

        # compare to other platforms
        # print('wasm!!!!')
        other_platforms = [
            "native",
            "sdk",
            "wasm",
            "crun_sdk",
            "crun_wasm",
            "gvisor_sdk",
        ]
        other_platforms_total_syscalls = dict()
        other_platforms_context_switches = dict()
        for other_platform in other_platforms:
            # print('other_platform lang workload', other_platform, lang, workload)
            try:
                other_platforms_total_syscalls[other_platform] = sum(
                    data[other_platform][lang][workload]["syscount"].values()
                )
                other_platforms_context_switches[other_platform] = data[other_platform][
                    lang
                ][workload]["context-switches"]
            except KeyError:
                pass  # we can safely ignore the key error for some workloads
            except Exception as e:
                print(
                    "failed to sum syscount and context-switches for the other_platform",
                    other_platform,
                    "lang",
                    lang,
                    "workload",
                    workload,
                    "error:",
                    e,
                )
        xs, ys = get_dict_keys_values(other_platforms_total_syscalls)
        plot_bar_chart(
            xs,
            ys,
            output_path=os.path.join(
                output_dir,
                "peaks",
                f"{workload}-{other_platform}-{lang}-total-syscalls.svg",
            ),
            title=f"workload {workload} and language {language}",
            xlabel="platform",
            ylabel="total number of syscalls",
            print_path=False,
        )
        xs, ys = get_dict_keys_values(other_platforms_context_switches)
        plot_bar_chart(
            xs,
            ys,
            output_path=os.path.join(
                output_dir,
                "peaks",
                f"{workload}-{other_platform}-{lang}-context-switches.svg",
            ),
            title=f"workload {workload} and language {language}",
            xlabel="platform",
            ylabel="context switches",
            print_path=False,
        )


def get_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--input-json",
        dest="input_json",
        type=str,
        required=False,
        default="",
        help="path to the json file containing performance data",
    )
    parser.add_argument(
        "--input-dir",
        dest="input_dir",
        type=str,
        required=False,
        default="",
        help="path to the directory containing the raw profiling output",
    )
    parser.add_argument(
        "--run-perf",
        dest="run_perf",
        action=argparse.BooleanOptionalAction,
        default=False,
        help="run perf tools to analyze the data and generate flamegraphs, for use with --input-dir",
    )
    parser.add_argument(
        "--output",
        type=str,
        required=False,
        default="./output_results",
        help="path to the output directory, will be created if it doesn't exist",
    )
    return parser


def main() -> None:
    # Tests for utility functions
    # test_utils()

    parser = get_parser()
    args = parser.parse_args()
    print("running with args:", args)

    if args.input_json == "" and args.input_dir == "":
        raise ValueError("please provide either --input-json or --input-dir")

    perf_data_path = Path(args.input_json).resolve()
    output_dir = Path(args.output).resolve()

    if args.input_dir != "":
        # Collect all performance profile data into a single JSON file.
        # Also has the option of running the profiling tools to generate the data.
        data_dir = Path(args.input_dir).resolve()
        assert data_dir.is_file(), f"input directory {data_dir} doesn't exist"
        if args.run_perf:
            print(
                "Also running perf tools to analyze the data and generate flamegraphs"
            )
        perf_data_path = collect_data_into_json(
            input_dir=str(data_dir),
            output_dir=str(output_dir),
            run_perf=args.run_perf,
        )

    # Create the graphs
    assert perf_data_path.is_file(), f"input {perf_data_path} doesn't exist"
    plot_graphs(data_path=str(perf_data_path), output_dir=str(output_dir))


if __name__ == "__main__":
    main()
