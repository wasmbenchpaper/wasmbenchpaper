#include <iostream>
#include <chrono>
#include <fstream>
#include <sys/stat.h>

int copy_file(std::string &src, std::string &dst)
{
    try
    {
        {
            struct stat s;
            if (stat(dst.c_str(), &s) != 0)
            {
                if (errno != ENOENT)
                {
                    printf("failed to stat the destination file\n");
                    return -1;
                }
            }
            else
            {
                if (s.st_mode & S_IFDIR)
                {
                    std::string src_filename = src.substr(src.find_last_of("/\\") + 1);
                    dst += "/" + src_filename;
                }
            }
        }
        // if (std::filesystem::is_directory(dst))
        // {
        //     auto src1 = std::filesystem::path(src);
        //     auto src_filename = src1.filename();
        //     auto dst1 = std::filesystem::path(dst);
        //     dst1 /= src_filename;
        //     dst = dst1.string();
        // }
        auto src_stream = std::ifstream(src);
        auto dst_stream = std::ofstream(dst);
        dst_stream << src_stream.rdbuf();
    }
    catch (int e)
    {
        std::cerr << "exception during copying. error: " << e;
        return 1;
    }
    return 0;
}

int main(int argc, char *argv[])
{
    // std::cout << "got " << argc << " args\n";
    if (argc != 3)
    {
        std::cerr << "usage: copy path/to/src/file path/to/dest/file/or/folder" << std::endl;
        exit(1);
    }
    std::cout << "running with args: [";
    for (int i = 0; i < argc; i++)
    {
        std::cout << argv[i];
        if (i != argc - 1)
            std::cout << ", ";
    }
    std::cout << "]" << std::endl;
    auto input_path = std::string(argv[1]);
    auto output_path = std::string(argv[2]);
    std::cout << "copying" << std::endl;
    auto t0 = std::chrono::high_resolution_clock::now();
    if (copy_file(input_path, output_path) != 0)
    {
        std::cerr << "failed to copy the file" << std::endl;
        exit(1);
    }
    auto t1 = std::chrono::high_resolution_clock::now();
    auto duration = t1 - t0;
    std::cout << "[info] copy done in: " << duration.count() << " ns" << std::endl;
    return 0;
}
