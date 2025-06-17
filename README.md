# CMake download shared resource

This CMake project demonstrates a safe way to download shared resources in parallel builds using file locking mechanisms.

## 🎯 Purpose

When building projects that require downloading external resources (like toolchains, SDKs, or large dependencies), we need to ensure that:

- Multiple parallel builds don't try to download the same resource simultaneously
- The download happens only once
- Failed downloads don't leave the build in an inconsistent state
- The process is safe across multiple processes and build directories

## 🔧 How It Works

The project uses CMake's built-in file locking mechanism to safely coordinate downloads:

1. Check if resource is already downloaded (via sentinel file)
2. Acquire a lock file with timeout
3. Double-check for race conditions after lock acquisition
4. Download the resource if needed
5. Create a sentinel file upon successful download
6. Release the lock

## 🚀 Usage

Simply include the project in your build:

```bash
cmake -B build
cmake --build build
```
