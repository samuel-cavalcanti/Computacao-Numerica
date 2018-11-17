
cmake_minimum_required (VERSION 2.6)
project (findByColor)

find_package( OpenCV REQUIRED ) 

set(CMAKE_CXX_STANDARD 11)



file(GLOB_RECURSE SOURCES sources/*.cpp)
file(GLOB_RECURSE HEADERS sources/*.hpp)

set (INCLUDE_DIRS "")
foreach(_headerFile ${HEADERS})
    get_filename_component(_dir ${_headerFile} PATH)
    list(APPEND INCLUDE_DIRS ${_dir})
endforeach()
list(REMOVE_DUPLICATES INCLUDE_DIRS)




add_executable(findByColor
	       main.cpp	
               ${SOURCES}
	       ${HEADERS})
           

target_link_libraries( findByColor ${OpenCV_LIBS} )
target_include_directories(findByColor PRIVATE ${INCLUDE_DIRS})

message("file" ${HEADERS} )





