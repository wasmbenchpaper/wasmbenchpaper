package main

import (
	"fmt"
	"io"
	"os"
	"path"
	"path/filepath"
)

func copyFileContents(src, dst string) (err error) {
	f, err := os.Stat(src)
	if err != nil {
		return err
	}
	in, err := os.Open(src)
	if err != nil {
		return err
	}
	defer in.Close()
	out, err := os.OpenFile(dst, os.O_CREATE|os.O_WRONLY, f.Mode())
	if err != nil {
		return err
	}
	defer func() {
		cerr := out.Close()
		if err == nil {
			err = cerr
		}
	}()
	if _, err = io.Copy(out, in); err != nil {
		return err
	}
	return
}

func CopyFile(src, dst string) (err error) {
	sfi, err := os.Stat(src)
	if err != nil {
		return
	}
	if !sfi.Mode().IsRegular() {
		// cannot copy non-regular files (e.g., directories,
		// symlinks, devices, etc.)
		return fmt.Errorf("CopyFile: non-regular source file %s (%q)", sfi.Name(), sfi.Mode().String())
	}
	dfi, err := os.Stat(dst)
	if err != nil {
		if !os.IsNotExist(err) {
			return
		}
	} else {
		if !dfi.Mode().IsRegular() {
			if !dfi.IsDir() {
				return fmt.Errorf("CopyFile: non-regular destination file %s (%q)", dfi.Name(), dfi.Mode().String())
			}
			srcFileName := filepath.Base(src)
			dst = path.Join(dst, srcFileName)
		}
		if os.SameFile(sfi, dfi) {
			return
		}
	}
	err = copyFileContents(src, dst)
	return
}

func main() {
	if len(os.Args) != 3 {
		fmt.Println("usage: copy path/to/src/file path/to/dest/file/or/folder")
		os.Exit(1)
	}
	// fmt.Println("running with args:", os.Args)
	input_path := os.Args[1]
	output_path := os.Args[2]
	// fmt.Println("copying")
	// t0 := time.Now()
	if err := CopyFile(input_path, output_path); err != nil {
		panic(err)
	}
	// t1 := time.Now()
	// fmt.Printf("[info] copy done in: %v ns\n", t1.Sub(t0).Nanoseconds())
}
