set(WAIT_FOR_LOCK_TIMEOUT 60) # Value is in seconds [s]

if(EXISTS "${SENTINEL_FILE}")
    message(STATUS "Sentinel file found: ${SENTINEL_FILE}. Archive already downloaded and extracted. Skipping.")
    return()
endif()

message(STATUS "Attempting to acquire lock for: ${LOCK_FILE}.")
file(LOCK ${LOCK_FILE}
    GUARD PROCESS
    TIMEOUT ${WAIT_FOR_LOCK_TIMEOUT}
    RESULT_VARIABLE LOCK_RESULT
)

if(LOCK_RESULT EQUAL 0)
    message(STATUS "Lock acquired. Checking for archive again to handle race conditions.")
    if(EXISTS "${SENTINEL_FILE}")
        message(STATUS "Sentinel file found after acquiring lock: ${SENTINEL_FILE}. Another process finished. Releasing lock.")
        file(LOCK "${LOCK_FILE}" RELEASE)
        return()
    endif()

    message(STATUS "Downloading ${ARCHIVE_URL} to ${ARCHIVE_PATH}...")
    file(DOWNLOAD "${ARCHIVE_URL}" "${ARCHIVE_PATH}"
        STATUS DOWNLOAD_STATUS
    )
    list(GET DOWNLOAD_STATUS 0 DOWNLOAD_STATUS_CODE)
    if(NOT DOWNLOAD_STATUS_CODE STREQUAL "0")
        file(LOCK "${LOCK_FILE}" RELEASE)
        message(FATAL_ERROR "Failed to download archive: ${ARCHIVE_URL}.")
    else()
        string(TIMESTAMP TIMESTAMP)
        message(STATUS "Archive downloaded successfully to: ${ARCHIVE_PATH}.")
        file(WRITE "${SENTINEL_FILE}" "Archive ${ARCHIVE_URL} downloaded and extracted successfully on ${TIMESTAMP}\n")
        message(STATUS "Sentinel file created: ${SENTINEL_FILE}.")
    endif()

    file(LOCK "${LOCK_FILE}" RELEASE)
    message(STATUS "Lock released.")
else()
    message(FATAL_ERROR "Failed to acquire lock for: ${LOCK_FILE} after ${WAIT_FOR_LOCK_TIMEOUT}s. Another process might be stuck or failed.")
endif()
