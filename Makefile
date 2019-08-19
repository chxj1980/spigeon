#BUILDMAKE edit-mode: -*- Makefile -*-
####################64Bit Mode####################
ifeq ($(shell uname -m), x86_64)
CC=gcc
CXX=g++
CPPFLAGS=-D_GNU_SOURCE \
  -D__STDC_LIMIT_MACROS \
  -DFRAMEWORK_VERSION="\"`./version.sh`\""
CFLAGS=-g \
  -ggdb \
  -pipe \
  -W \
  -Wall \
  -O0 \
  -DDEBUG
CXXFLAGS=-g \
  -ggdb \
  -pipe \
  -W \
  -Wall \
  -O0 \
  -DDEBUG
INCPATH=-I. \
  -I./src \
  -I./deps/libev-4.11 \
  -I./deps/evhttpclient \
  -I./deps \
  -I./deps/protobuf/src
DEP_INCPATH=-I../../newcommon/mcpack \
  -I../../newcommon/mcpack/include \
  -I../../newcommon/mcpack/output \
  -I../../newcommon/mcpack/output/include


#BUILDMAKE UUID
BUILDMAKE_MD5=3e31920e1357168a821b249691fed9b5  BUILDMAKE


.PHONY:all
all:buildmake_makefile_check libzframework.a 
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;32;40mall[0m']"
	@echo "make all done"

PHONY:buildmake_makefile_check
buildmake_makefile_check:
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;32;40mbuildmake_makefile_check[0m']"
	#in case of error, update "Makefile" by "buildmake"
	@echo "$(BUILDMAKE_MD5)" > buildmake.md5
	@md5sum -c --status buildmake.md5
	@rm -f buildmake.md5

.PHONY:clean
clean:
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;32;40mclean[0m']"
	rm -rf libzframework.a
	rm -rf ./output/lib/libzframework.a
	rm -rf ./output/include/dispatcher.h
	rm -rf ./output/include/event.h
	rm -rf ./output/include/module.h
	rm -rf ./output/include/server.h
	rm -rf ./output/include/thread.h
	rm -rf ./output/include/worker.h
	rm -rf ./output/include/http_client.h
	rm -rf ./output/include/config_file.h
	rm -rf ./output/include/crc32c.h
	rm -rf ./output/include/def.h
	rm -rf ./output/include/file.h
	rm -rf ./output/include/hash.h
	rm -rf ./output/include/key_lock.h
	rm -rf ./output/include/list.h
	rm -rf ./output/include/lock.h
	rm -rf ./output/include/log.h
	rm -rf ./output/include/network.h
	rm -rf ./output/include/nshead.h
	rm -rf ./output/include/pack.h
	rm -rf ./output/include/profiler.h
	rm -rf ./output/include/queue.h
	rm -rf ./output/include/scoped_ptr.h
	rm -rf ./output/include/sds.h
	rm -rf ./output/include/slice.h
	rm -rf ./output/include/stat.h
	rm -rf ./output/include/status.h
	rm -rf ./output/include/store_define.h
	rm -rf ./output/include/store_error.h
	rm -rf ./output/include/string.h
	rm -rf ./output/include/url_snprintf.h
	rm -rf ./output/include/utils.h
	rm -rf ./output/include/zmalloc.h
	rm -rf ./output/include/zmalloc_define.h
	rm -rf ./output/include/store_framework.h
	rm -rf src/server/zframework_dispatcher.o
	rm -rf src/server/zframework_event.o
	rm -rf src/server/zframework_server.o
	rm -rf src/server/zframework_thread.o
	rm -rf src/server/zframework_worker.o
	rm -rf src/client/zframework_http_client.o
	rm -rf src/util/zframework_config_file.o
	rm -rf src/util/zframework_crc32c.o
	rm -rf src/util/zframework_file.o
	rm -rf src/util/zframework_key_lock.o
	rm -rf src/util/zframework_log.o
	rm -rf src/util/zframework_network.o
	rm -rf src/util/zframework_pack.o
	rm -rf src/util/zframework_sds.o
	rm -rf src/util/zframework_stat.o
	rm -rf src/util/zframework_status.o
	rm -rf src/util/zframework_string.o
	rm -rf src/util/zframework_url_snprintf.o
	rm -rf src/util/zframework_utils.o
	rm -rf src/util/zframework_zmalloc.o

.PHONY:dist
dist:
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;32;40mdist[0m']"
	tar czvf output.tar.gz output
	@echo "make dist done"

.PHONY:distclean
distclean:clean
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;32;40mdistclean[0m']"
	rm -f output.tar.gz
	@echo "make distclean done"

.PHONY:love
love:
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;32;40mlove[0m']"
	@echo "make love done"

libzframework.a:src/server/zframework_dispatcher.o \
  src/server/zframework_event.o \
  src/server/zframework_server.o \
  src/server/zframework_thread.o \
  src/server/zframework_worker.o \
  src/client/zframework_http_client.o \
  src/util/zframework_config_file.o \
  src/util/zframework_crc32c.o \
  src/util/zframework_file.o \
  src/util/zframework_key_lock.o \
  src/util/zframework_log.o \
  src/util/zframework_network.o \
  src/util/zframework_pack.o \
  src/util/zframework_sds.o \
  src/util/zframework_stat.o \
  src/util/zframework_status.o \
  src/util/zframework_string.o \
  src/util/zframework_url_snprintf.o \
  src/util/zframework_utils.o \
  src/util/zframework_zmalloc.o \
  ./src/server/dispatcher.h \
  ./src/server/event.h \
  ./src/server/module.h \
  ./src/server/server.h \
  ./src/server/thread.h \
  ./src/server/worker.h \
  ./src/client/http_client.h \
  ./src/util/config_file.h \
  ./src/util/crc32c.h \
  ./src/util/def.h \
  ./src/util/file.h \
  ./src/util/hash.h \
  ./src/util/key_lock.h \
  ./src/util/list.h \
  ./src/util/lock.h \
  ./src/util/log.h \
  ./src/util/network.h \
  ./src/util/nshead.h \
  ./src/util/pack.h \
  ./src/util/profiler.h \
  ./src/util/queue.h \
  ./src/util/scoped_ptr.h \
  ./src/util/sds.h \
  ./src/util/slice.h \
  ./src/util/stat.h \
  ./src/util/status.h \
  ./src/util/store_define.h \
  ./src/util/store_error.h \
  ./src/util/string.h \
  ./src/util/url_snprintf.h \
  ./src/util/utils.h \
  ./src/util/zmalloc.h \
  ./src/util/zmalloc_define.h \
  ./src/store_framework.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;32;40mlibzframework.a[0m']"
	ar crs libzframework.a src/server/zframework_dispatcher.o \
  src/server/zframework_event.o \
  src/server/zframework_server.o \
  src/server/zframework_thread.o \
  src/server/zframework_worker.o \
  src/client/zframework_http_client.o \
  src/util/zframework_config_file.o \
  src/util/zframework_crc32c.o \
  src/util/zframework_file.o \
  src/util/zframework_key_lock.o \
  src/util/zframework_log.o \
  src/util/zframework_network.o \
  src/util/zframework_pack.o \
  src/util/zframework_sds.o \
  src/util/zframework_stat.o \
  src/util/zframework_status.o \
  src/util/zframework_string.o \
  src/util/zframework_url_snprintf.o \
  src/util/zframework_utils.o \
  src/util/zframework_zmalloc.o
	mkdir -p ./output/lib
	cp -f --link libzframework.a ./output/lib
	mkdir -p ./output/include
	cp -f --link ./src/server/dispatcher.h ./src/server/event.h ./src/server/module.h ./src/server/server.h ./src/server/thread.h ./src/server/worker.h ./src/client/http_client.h ./src/util/config_file.h ./src/util/crc32c.h ./src/util/def.h ./src/util/file.h ./src/util/hash.h ./src/util/key_lock.h ./src/util/list.h ./src/util/lock.h ./src/util/log.h ./src/util/network.h ./src/util/nshead.h ./src/util/pack.h ./src/util/profiler.h ./src/util/queue.h ./src/util/scoped_ptr.h ./src/util/sds.h ./src/util/slice.h ./src/util/stat.h ./src/util/status.h ./src/util/store_define.h ./src/util/store_error.h ./src/util/string.h ./src/util/url_snprintf.h ./src/util/utils.h ./src/util/zmalloc.h ./src/util/zmalloc_define.h ./src/store_framework.h ./output/include

src/server/zframework_dispatcher.o:src/server/dispatcher.cpp \
  src/server/event.h \
  src/util/queue.h \
  src/server/worker.h \
  src/server/thread.h \
  src/server/server.h \
  src/util/config_file.h \
  src/server/module.h \
  src/server/dispatcher.h \
  src/util/lock.h \
  src/util/store_define.h \
  src/util/log.h \
  src/util/log.h \
  src/util/sds.h \
  src/util/slice.h \
  src/util/network.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;32;40msrc/server/zframework_dispatcher.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/server/zframework_dispatcher.o src/server/dispatcher.cpp

src/server/zframework_event.o:src/server/event.cpp \
  deps/libev-4.11/ev.h \
  src/server/event.h \
  src/util/queue.h \
  src/util/log.h \
  src/util/store_define.h \
  src/util/log.h \
  src/util/utils.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;32;40msrc/server/zframework_event.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/server/zframework_event.o src/server/event.cpp

src/server/zframework_server.o:src/server/server.cpp \
  src/server/server.h \
  src/util/config_file.h \
  src/server/module.h \
  src/server/dispatcher.h \
  src/server/thread.h \
  src/util/queue.h \
  src/util/lock.h \
  src/util/store_define.h \
  src/util/log.h \
  src/util/log.h \
  src/util/zmalloc.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;32;40msrc/server/zframework_server.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/server/zframework_server.o src/server/server.cpp

src/server/zframework_thread.o:src/server/thread.cpp \
  src/server/thread.h \
  src/util/queue.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;32;40msrc/server/zframework_thread.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/server/zframework_thread.o src/server/thread.cpp

src/server/zframework_worker.o:src/server/worker.cpp \
  src/server/worker.h \
  src/server/thread.h \
  src/util/queue.h \
  src/server/server.h \
  src/util/config_file.h \
  src/server/module.h \
  src/server/dispatcher.h \
  src/util/lock.h \
  src/util/store_define.h \
  src/util/log.h \
  src/util/log.h \
  src/util/sds.h \
  src/util/slice.h \
  src/server/event.h \
  src/util/network.h \
  src/util/zmalloc.h \
  src/util/stat.h \
  src/util/scoped_ptr.h \
  src/util/status.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;32;40msrc/server/zframework_worker.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/server/zframework_worker.o src/server/worker.cpp

src/client/zframework_http_client.o:src/client/http_client.cpp \
  src/client/http_client.h \
  src/util/slice.h \
  deps/evhttpclient/evhttpclient.h \
  deps/libev-4.11/ev.h \
  deps/evhttpclient/url.h \
  deps/evhttpclient/http_parser.h \
  src/server/event.h \
  src/util/queue.h \
  src/util/log.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;32;40msrc/client/zframework_http_client.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/client/zframework_http_client.o src/client/http_client.cpp

src/util/zframework_config_file.o:src/util/config_file.cpp \
  src/util/config_file.h \
  src/util/utils.h \
  src/util/sds.h \
  src/util/zmalloc.h \
  src/util/log.h \
  deps/new-config/config.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;32;40msrc/util/zframework_config_file.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/util/zframework_config_file.o src/util/config_file.cpp

src/util/zframework_crc32c.o:src/util/crc32c.cpp \
  src/util/crc32c.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;32;40msrc/util/zframework_crc32c.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/util/zframework_crc32c.o src/util/crc32c.cpp

src/util/zframework_file.o:src/util/file.cpp \
  src/util/file.h \
  src/util/log.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;32;40msrc/util/zframework_file.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/util/zframework_file.o src/util/file.cpp

src/util/zframework_key_lock.o:src/util/key_lock.cpp \
  src/util/key_lock.h \
  src/util/hash.h \
  src/util/slice.h \
  src/util/store_define.h \
  src/util/log.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;32;40msrc/util/zframework_key_lock.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/util/zframework_key_lock.o src/util/key_lock.cpp

src/util/zframework_log.o:src/util/log.cpp \
  src/util/url_snprintf.h \
  src/util/zmalloc.h \
  src/server/event.h \
  src/util/queue.h \
  src/util/def.h \
  src/util/log.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;32;40msrc/util/zframework_log.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/util/zframework_log.o src/util/log.cpp

src/util/zframework_network.o:src/util/network.cpp \
  src/util/log.h \
  src/util/network.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;32;40msrc/util/zframework_network.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/util/zframework_network.o src/util/network.cpp

src/util/zframework_pack.o:src/util/pack.cpp \
  src/util/pack.h \
  src/util/log.h \
  src/util/slice.h \
  src/util/zmalloc.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;32;40msrc/util/zframework_pack.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/util/zframework_pack.o src/util/pack.cpp

src/util/zframework_sds.o:src/util/sds.cpp \
  src/util/sds.h \
  src/util/zmalloc.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;32;40msrc/util/zframework_sds.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/util/zframework_sds.o src/util/sds.cpp

src/util/zframework_stat.o:src/util/stat.cpp \
  src/util/stat.h \
  src/util/lock.h \
  src/util/store_define.h \
  src/util/log.h \
  src/util/log.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;32;40msrc/util/zframework_stat.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/util/zframework_stat.o src/util/stat.cpp

src/util/zframework_status.o:src/util/status.cpp \
  src/util/status.h \
  src/util/slice.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;32;40msrc/util/zframework_status.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/util/zframework_status.o src/util/status.cpp

src/util/zframework_string.o:src/util/string.cpp \
  src/util/string.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;32;40msrc/util/zframework_string.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/util/zframework_string.o src/util/string.cpp

src/util/zframework_url_snprintf.o:src/util/url_snprintf.cpp \
  src/util/url_snprintf.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;32;40msrc/util/zframework_url_snprintf.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/util/zframework_url_snprintf.o src/util/url_snprintf.cpp

src/util/zframework_utils.o:src/util/utils.cpp \
  src/util/utils.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;32;40msrc/util/zframework_utils.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/util/zframework_utils.o src/util/utils.cpp

src/util/zframework_zmalloc.o:src/util/zmalloc.cpp \
  src/util/zmalloc_define.h \
  src/util/zmalloc.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;32;40msrc/util/zframework_zmalloc.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/util/zframework_zmalloc.o src/util/zmalloc.cpp

endif #ifeq ($(shell uname -m), x86_64)


