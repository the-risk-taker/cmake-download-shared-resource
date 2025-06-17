cmake_minimum_required(VERSION 3.20)
project(DownloadSharedResources LANGUAGES CXX)

set(ARCHIVE_URL "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.0/clang-20.1.0.src.tar.xz")
set(ARCHIVE_DIR "${CMAKE_SOURCE_DIR}/archives")
set(ARCHIVE_PATH "${ARCHIVE_DIR}/archive.zip")
set(SENTINEL_FILE "${ARCHIVE_DIR}/sentinel.txt")
set(LOCK_FILE "${ARCHIVE_DIR}/archive.lock")

execute_process(COMMAND ${CMAKE_COMMAND}
    -D "ARCHIVE_URL=${ARCHIVE_URL}"
    -D "ARCHIVE_PATH=${ARCHIVE_PATH}"
    -D "LOCK_FILE=${LOCK_FILE}"
    -D "SENTINEL_FILE=${SENTINEL_FILE}"
    -P "${CMAKE_SOURCE_DIR}/cmake/download_and_extract.cmake"
)
