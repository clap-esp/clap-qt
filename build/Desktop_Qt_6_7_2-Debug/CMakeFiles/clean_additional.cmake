# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles/appclap_v1_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/appclap_v1_autogen.dir/ParseCache.txt"
  "appclap_v1_autogen"
  )
endif()
