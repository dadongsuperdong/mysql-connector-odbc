# Copyright (c) 2009, 2019, Oracle and/or its affiliates. All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License, version 2.0, as
# published by the Free Software Foundation.
#
# This program is also distributed with certain software (including
# but not limited to OpenSSL) that is licensed under separate terms,
# as designated in a particular file or component or in included license
# documentation.  The authors of MySQL hereby grant you an
# additional permission to link the program and your derivative works
# with the separately licensed software that they have included with
# MySQL.
#
# Without limiting anything contained in the foregoing, this file,
# which is part of MySQL Connector/C++, is also subject to the
# Universal FOSS Exception, version 1.0, a copy of which can be found at
# http://oss.oracle.com/licenses/universal-foss-exception.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License, version 2.0, for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA


function(setup_ssl_libs)
  IF(MYSQL8)
    IF(WIN32)
      SET(CMAKE_FIND_LIBRARY_SUFFIXES ".dll")
    ELSEIF(APPLE)
      SET(CMAKE_FIND_LIBRARY_SUFFIXES ".dylib")
    ENDIF()

    find_library(OPENSSL_LIBRARY
      NAMES libssl-1_1 libssl-1_1-x64 libssl ssl ssleay32
      PATH_SUFFIXES private
      PATHS ${MYSQL_DIR}/bin ${MYSQL_DIR}/lib
      NO_DEFAULT_PATH
    )

    find_library(CRYPTO_LIBRARY
      NAMES libcrypto-1_1 libcrypto-1_1-x64 libcrypto crypto libeay32
      PATH_SUFFIXES private
      PATHS ${MYSQL_DIR}/bin ${MYSQL_DIR}/lib
      NO_DEFAULT_PATH
    )
    message("-- OpenSSL library: ${OPENSSL_LIBRARY}")
    message("-- OpenSSL crypto library: ${CRYPTO_LIBRARY}")

    get_filename_component(OPENSSL_LIB_NAME "${OPENSSL_LIBRARY}" NAME)
    get_filename_component(CRYPTO_LIB_NAME "${CRYPTO_LIBRARY}" NAME)
    get_filename_component(OPENSSL_LIB_NAME_WE "${OPENSSL_LIBRARY}" NAME_WE)
    get_filename_component(CRYPTO_LIB_NAME_WE "${CRYPTO_LIBRARY}" NAME_WE)
    get_filename_component(OPENSSL_LIB_DIR "${OPENSSL_LIBRARY}" DIRECTORY)
    get_filename_component(CRYPTO_LIB_DIR "${CRYPTO_LIBRARY}" DIRECTORY)
    
    SET(_SSL_PATH ${OPENSSL_LIB_DIR})

    link_directories(${OPENSSL_LIB_DIR})
    file(GLOB glob1
      "${OPENSSL_LIB_DIR}/${OPENSSL_LIB_NAME_WE}*"
    )

    file(GLOB glob2
      "${OPENSSL_LIB_DIR}/${CRYPTO_LIB_NAME_WE}*"
    )

    if(MYSQLCLIENT_STATIC_LINKING)

      foreach(lib ${glob1} ${glob2})

        message("-- bundling OpenSSL library: ${lib}")

        install(FILES ${lib}
          DESTINATION ${LIB_SUBDIR}
          COMPONENT OpenSSLDll
        )

      endforeach()

    endif()

  ENDIF(MYSQL8)
endfunction(setup_ssl_libs)