function show_files(files) {
    const elem = document.querySelector('#files-in-curr-dir');
    files.forEach(f => {
        const e = document.createElement('li');
        const a = document.createElement('a');
        a.href = f;
        a.textContent = f;
        e.appendChild(a);
        elem.appendChild(e);
    });
}

async function main() {
    console.log('main start');
    const res = await fetch('/api/v1/files');
    if (!res.ok) return console.error('failed to fetch the files');
    const files = await res.json();
    console.log('fetched the list of files:', files);
    show_files(files);
    console.log('main end');
}

main().catch(console.error);
