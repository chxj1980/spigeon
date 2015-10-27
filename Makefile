#BUILDMAKE edit-mode: -*- Makefile -*-
####################64Bit Mode####################
ifeq ($(shell uname -m), x86_64)
CC=gcc
CXX=g++
CXXFLAGS=-g \
  -ggdb \
  -pipe \
  -W \
  -Wall \
  -O0 \
  -DDEBUG
CFLAGS=-g \
  -ggdb \
  -pipe \
  -W \
  -Wall \
  -O0 \
  -DDEBUG
CPPFLAGS=-D_GNU_SOURCE \
  -D__STDC_LIMIT_MACROS \
  -DFRAMEWORK_VERSION="\"`./version.sh`\""
INCPATH=-I. \
  -I./src \
  -I./deps/libev-4.11 \
  -I./deps/evhttpclient \
  -I./deps \
  -I./deps/protobuf/src
DEP_INCPATH=-I../../newcommon/mcpack \
  -I../../newcommon/mcpack/include \
  -I../../newcommon/mcpack/output \
  -I../../newcommon/mcpack/output/include \
  -I../../newlib2-64/bsl \
  -I../../newlib2-64/bsl/include \
  -I../../newlib2-64/bsl/output \
  -I../../newlib2-64/bsl/output/include

#============ CCP vars ============
CCHECK=@ccheck.py
CCHECK_FLAGS=
PCLINT=@pclint
PCLINT_FLAGS=
CCP=@ccp.py
CCP_FLAGS=


#BUILDMAKE UUID
BUILDMAKE_MD5=539daa06899f29c63342f172c3795cd3  BUILDMAKE


.PHONY:all
all:buildmake_makefile_check libstoreframework-partial.a 
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40mall[0m']"
	@echo "make all done"

.PHONY:buildmake_makefile_check
buildmake_makefile_check:
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40mbuildmake_makefile_check[0m']"
	#in case of error, update 'Makefile' by 'buildmake'
	@echo "$(BUILDMAKE_MD5)" > buildmake.md5
	@md5sum -c --status buildmake.md5
	@rm -f buildmake.md5

.PHONY:ccpClean
ccpclean:
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40mccpclean[0m']"
	@echo "make ccpclean done"

.PHONY:clean
clean:ccpClean
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40mclean[0m']"
	rm -rf libstoreframework-partial.a
	rm -rf ./output/lib/libstoreframework-partial.a
	rm -rf src/server/storeframework-partial_db_dispatcher.o
	rm -rf src/server/storeframework-partial_db_server.o
	rm -rf src/server/storeframework-partial_db_worker.o
	rm -rf src/server/storeframework-partial_dispatcher.o
	rm -rf src/server/storeframework-partial_event.o
	rm -rf src/server/storeframework-partial_nshead_worker.o
	rm -rf src/server/storeframework-partial_server.o
	rm -rf src/server/storeframework-partial_thread.o
	rm -rf src/server/storeframework-partial_worker.o
	rm -rf src/client/storeframework-partial_http_client.o
	rm -rf src/inc/storeframework-partial_version.o
	rm -rf src/db/storeframework-partial_db.o
	rm -rf src/db/storeframework-partial_env.o
	rm -rf src/db/storeframework-partial_recovery.o
	rm -rf src/db/storeframework-partial_request.o
	rm -rf src/db/storeframework-partial_response.o
	rm -rf src/binlog/storeframework-partial_big_file.o
	rm -rf src/binlog/storeframework-partial_binlog.o
	rm -rf src/util/storeframework-partial_config_file.o
	rm -rf src/util/storeframework-partial_crc32c.o
	rm -rf src/util/storeframework-partial_file.o
	rm -rf src/util/storeframework-partial_key_lock.o
	rm -rf src/util/storeframework-partial_log.o
	rm -rf src/util/storeframework-partial_network.o
	rm -rf src/util/storeframework-partial_pack.o
	rm -rf src/util/storeframework-partial_sds.o
	rm -rf src/util/storeframework-partial_stat.o
	rm -rf src/util/storeframework-partial_status.o
	rm -rf src/util/storeframework-partial_string.o
	rm -rf src/util/storeframework-partial_url_snprintf.o
	rm -rf src/util/storeframework-partial_utils.o
	rm -rf src/util/storeframework-partial_zmalloc.o
	rm -rf src/replication/storeframework-partial_replication.o
	rm -rf src/command/storeframework-partial_command.o
	rm -rf src/command/storeframework-partial_command_kv.o
	rm -rf src/command/storeframework-partial_command_list.o
	rm -rf src/command/storeframework-partial_command_stat.o
	rm -rf src/command/storeframework-partial_list.pb.o

.PHONY:dist
dist:
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40mdist[0m']"
	tar czvf output.tar.gz output
	@echo "make dist done"

.PHONY:distclean
distclean:clean
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40mdistclean[0m']"
	rm -f output.tar.gz
	@echo "make distclean done"

.PHONY:love
love:
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40mlove[0m']"
	@echo "make love done"

libstoreframework-partial.a:src/server/storeframework-partial_db_dispatcher.o \
  src/server/storeframework-partial_db_server.o \
  src/server/storeframework-partial_db_worker.o \
  src/server/storeframework-partial_dispatcher.o \
  src/server/storeframework-partial_event.o \
  src/server/storeframework-partial_nshead_worker.o \
  src/server/storeframework-partial_server.o \
  src/server/storeframework-partial_thread.o \
  src/server/storeframework-partial_worker.o \
  src/client/storeframework-partial_http_client.o \
  src/inc/storeframework-partial_version.o \
  src/db/storeframework-partial_db.o \
  src/db/storeframework-partial_env.o \
  src/db/storeframework-partial_recovery.o \
  src/db/storeframework-partial_request.o \
  src/db/storeframework-partial_response.o \
  src/binlog/storeframework-partial_big_file.o \
  src/binlog/storeframework-partial_binlog.o \
  src/util/storeframework-partial_config_file.o \
  src/util/storeframework-partial_crc32c.o \
  src/util/storeframework-partial_file.o \
  src/util/storeframework-partial_key_lock.o \
  src/util/storeframework-partial_log.o \
  src/util/storeframework-partial_network.o \
  src/util/storeframework-partial_pack.o \
  src/util/storeframework-partial_sds.o \
  src/util/storeframework-partial_stat.o \
  src/util/storeframework-partial_status.o \
  src/util/storeframework-partial_string.o \
  src/util/storeframework-partial_url_snprintf.o \
  src/util/storeframework-partial_utils.o \
  src/util/storeframework-partial_zmalloc.o \
  src/replication/storeframework-partial_replication.o \
  src/command/storeframework-partial_command.o \
  src/command/storeframework-partial_command_kv.o \
  src/command/storeframework-partial_command_list.o \
  src/command/storeframework-partial_command_stat.o \
  src/command/storeframework-partial_list.pb.o
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40mlibstoreframework-partial.a[0m']"
	ar crs libstoreframework-partial.a src/server/storeframework-partial_db_dispatcher.o \
  src/server/storeframework-partial_db_server.o \
  src/server/storeframework-partial_db_worker.o \
  src/server/storeframework-partial_dispatcher.o \
  src/server/storeframework-partial_event.o \
  src/server/storeframework-partial_nshead_worker.o \
  src/server/storeframework-partial_server.o \
  src/server/storeframework-partial_thread.o \
  src/server/storeframework-partial_worker.o \
  src/client/storeframework-partial_http_client.o \
  src/inc/storeframework-partial_version.o \
  src/db/storeframework-partial_db.o \
  src/db/storeframework-partial_env.o \
  src/db/storeframework-partial_recovery.o \
  src/db/storeframework-partial_request.o \
  src/db/storeframework-partial_response.o \
  src/binlog/storeframework-partial_big_file.o \
  src/binlog/storeframework-partial_binlog.o \
  src/util/storeframework-partial_config_file.o \
  src/util/storeframework-partial_crc32c.o \
  src/util/storeframework-partial_file.o \
  src/util/storeframework-partial_key_lock.o \
  src/util/storeframework-partial_log.o \
  src/util/storeframework-partial_network.o \
  src/util/storeframework-partial_pack.o \
  src/util/storeframework-partial_sds.o \
  src/util/storeframework-partial_stat.o \
  src/util/storeframework-partial_status.o \
  src/util/storeframework-partial_string.o \
  src/util/storeframework-partial_url_snprintf.o \
  src/util/storeframework-partial_utils.o \
  src/util/storeframework-partial_zmalloc.o \
  src/replication/storeframework-partial_replication.o \
  src/command/storeframework-partial_command.o \
  src/command/storeframework-partial_command_kv.o \
  src/command/storeframework-partial_command_list.o \
  src/command/storeframework-partial_command_stat.o \
  src/command/storeframework-partial_list.pb.o
	mkdir -p ./output/lib
	cp -f --link libstoreframework-partial.a ./output/lib

src/server/storeframework-partial_db_dispatcher.o:src/server/db_dispatcher.cpp \
  src/server/db_dispatcher.h \
  src/server/dispatcher.h \
  src/server/thread.h \
  src/util/queue.h \
  src/util/lock.h \
  src/util/store_define.h \
  src/util/log.h \
  src/util/log.h \
  src/server/server.h \
  src/util/config_file.h \
  src/inc/module.h \
  src/server/db_server.h \
  src/server/server.h \
  src/server/db_worker.h \
  src/server/nshead_worker.h \
  src/server/worker.h \
  src/util/sds.h \
  src/util/slice.h \
  src/util/nshead.h \
  src/server/server.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/server/storeframework-partial_db_dispatcher.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/server/storeframework-partial_db_dispatcher.o src/server/db_dispatcher.cpp

src/server/storeframework-partial_db_server.o:src/server/db_server.cpp \
  src/server/db_server.h \
  src/util/config_file.h \
  src/inc/module.h \
  src/server/server.h \
  src/server/db_dispatcher.h \
  src/server/dispatcher.h \
  src/server/thread.h \
  src/util/queue.h \
  src/util/lock.h \
  src/util/store_define.h \
  src/util/log.h \
  src/util/log.h \
  src/server/server.h \
  src/server/db_server.h \
  src/util/zmalloc.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/server/storeframework-partial_db_server.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/server/storeframework-partial_db_server.o src/server/db_server.cpp

src/server/storeframework-partial_db_worker.o:src/server/db_worker.cpp \
  src/server/db_worker.h \
  src/server/nshead_worker.h \
  src/server/worker.h \
  src/server/thread.h \
  src/util/queue.h \
  src/server/server.h \
  src/util/config_file.h \
  src/inc/module.h \
  src/server/dispatcher.h \
  src/util/lock.h \
  src/util/store_define.h \
  src/util/log.h \
  src/util/log.h \
  src/util/sds.h \
  src/util/slice.h \
  src/util/nshead.h \
  src/server/db_server.h \
  src/server/server.h \
  src/server/db_dispatcher.h \
  src/server/event.h \
  src/inc/env.h \
  src/util/log.h \
  src/util/store_define.h \
  src/inc/module.h \
  src/db/db.h \
  src/db/db_define.h \
  src/util/zmalloc.h \
  src/util/key_lock.h \
  src/util/hash.h \
  src/util/slice.h \
  src/inc/module.h \
  src/util/status.h \
  src/db/request.h \
  src/util/pack.h \
  src/util/slice.h \
  src/util/store_define.h \
  src/replication/replication.h \
  src/binlog/binlog.h \
  src/binlog/big_file.h \
  src/util/lock.h \
  src/inc/module.h \
  src/db/db_define.h \
  src/util/slice.h \
  src/util/network.h \
  src/inc/module.h \
  src/util/status.h \
  src/util/scoped_ptr.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/server/storeframework-partial_db_worker.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/server/storeframework-partial_db_worker.o src/server/db_worker.cpp

src/server/storeframework-partial_dispatcher.o:src/server/dispatcher.cpp \
  src/server/event.h \
  src/util/queue.h \
  src/server/db_worker.h \
  src/server/nshead_worker.h \
  src/server/worker.h \
  src/server/thread.h \
  src/server/server.h \
  src/util/config_file.h \
  src/inc/module.h \
  src/server/dispatcher.h \
  src/util/lock.h \
  src/util/store_define.h \
  src/util/log.h \
  src/util/log.h \
  src/util/sds.h \
  src/util/slice.h \
  src/util/nshead.h \
  src/server/db_server.h \
  src/server/server.h \
  src/util/network.h \
  src/util/log.h \
  src/server/dispatcher.h \
  src/inc/env.h \
  src/util/log.h \
  src/util/store_define.h \
  src/inc/module.h \
  src/util/store_define.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/server/storeframework-partial_dispatcher.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/server/storeframework-partial_dispatcher.o src/server/dispatcher.cpp

src/server/storeframework-partial_event.o:src/server/event.cpp \
  deps/libev-4.11/ev.h \
  src/server/event.h \
  src/util/queue.h \
  src/util/queue.h \
  src/util/log.h \
  src/util/store_define.h \
  src/util/log.h \
  src/util/utils.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/server/storeframework-partial_event.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/server/storeframework-partial_event.o src/server/event.cpp

src/server/storeframework-partial_nshead_worker.o:src/server/nshead_worker.cpp \
  src/server/nshead_worker.h \
  src/server/worker.h \
  src/server/thread.h \
  src/util/queue.h \
  src/server/server.h \
  src/util/config_file.h \
  src/inc/module.h \
  src/server/dispatcher.h \
  src/util/lock.h \
  src/util/store_define.h \
  src/util/log.h \
  src/util/log.h \
  src/util/sds.h \
  src/util/slice.h \
  src/util/nshead.h \
  src/util/nshead.h \
  src/util/zmalloc.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/server/storeframework-partial_nshead_worker.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/server/storeframework-partial_nshead_worker.o src/server/nshead_worker.cpp

src/server/storeframework-partial_server.o:src/server/server.cpp \
  src/server/server.h \
  src/util/config_file.h \
  src/inc/module.h \
  src/server/dispatcher.h \
  src/server/thread.h \
  src/util/queue.h \
  src/util/lock.h \
  src/util/store_define.h \
  src/util/log.h \
  src/util/log.h \
  src/server/server.h \
  src/util/zmalloc.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/server/storeframework-partial_server.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/server/storeframework-partial_server.o src/server/server.cpp

src/server/storeframework-partial_thread.o:src/server/thread.cpp \
  src/server/thread.h \
  src/util/queue.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/server/storeframework-partial_thread.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/server/storeframework-partial_thread.o src/server/thread.cpp

src/server/storeframework-partial_worker.o:src/server/worker.cpp \
  src/server/worker.h \
  src/server/thread.h \
  src/util/queue.h \
  src/server/server.h \
  src/util/config_file.h \
  src/inc/module.h \
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
  src/util/lock.h \
  src/util/scoped_ptr.h \
  src/util/status.h \
  src/util/slice.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/server/storeframework-partial_worker.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/server/storeframework-partial_worker.o src/server/worker.cpp

src/client/storeframework-partial_http_client.o:src/client/http_client.cpp \
  src/client/http_client.h \
  src/util/slice.h \
  deps/evhttpclient/evhttpclient.h \
  deps/libev-4.11/ev.h \
  deps/evhttpclient/url.h \
  deps/evhttpclient/http_parser.h \
  src/server/event.h \
  src/util/queue.h \
  src/util/log.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/client/storeframework-partial_http_client.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/client/storeframework-partial_http_client.o src/client/http_client.cpp

src/inc/storeframework-partial_version.o:src/inc/version.cpp \
  src/inc/version.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/inc/storeframework-partial_version.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/inc/storeframework-partial_version.o src/inc/version.cpp

src/db/storeframework-partial_db.o:src/db/db.cpp \
  src/db/db.h \
  src/db/db_define.h \
  src/util/zmalloc.h \
  src/util/key_lock.h \
  src/util/hash.h \
  src/util/slice.h \
  src/util/store_define.h \
  src/util/log.h \
  src/inc/module.h \
  src/util/status.h \
  src/binlog/binlog.h \
  src/binlog/big_file.h \
  src/util/lock.h \
  src/util/log.h \
  src/inc/module.h \
  src/command/command.h \
  src/util/status.h \
  src/util/slice.h \
  src/engine/engine.h \
  src/util/slice.h \
  src/inc/module.h \
  src/db/db_define.h \
  src/inc/env.h \
  src/util/log.h \
  src/util/store_define.h \
  src/inc/module.h \
  src/db/response.h \
  src/util/pack.h \
  src/util/nshead.h \
  src/db/request.h \
  src/util/slice.h \
  src/util/store_define.h \
  src/util/log.h \
  src/util/nshead.h \
  src/util/slice.h \
  src/util/stat.h \
  src/util/lock.h \
  src/util/store_define.h \
  src/util/config_file.h \
  src/util/scoped_ptr.h \
  src/util/status.h \
  src/engine/engine.h \
  src/util/utils.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/db/storeframework-partial_db.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/db/storeframework-partial_db.o src/db/db.cpp

src/db/storeframework-partial_env.o:src/db/env.cpp \
  src/inc/env.h \
  src/util/log.h \
  src/util/store_define.h \
  src/util/log.h \
  src/inc/module.h \
  src/binlog/binlog.h \
  src/binlog/big_file.h \
  src/util/lock.h \
  src/util/store_define.h \
  src/util/log.h \
  src/inc/module.h \
  src/db/db.h \
  src/db/db_define.h \
  src/util/zmalloc.h \
  src/util/key_lock.h \
  src/util/hash.h \
  src/util/slice.h \
  src/inc/module.h \
  src/util/status.h \
  src/db/db_define.h \
  src/engine/engine.h \
  src/util/slice.h \
  src/inc/module.h \
  src/server/db_server.h \
  src/util/config_file.h \
  src/inc/module.h \
  src/server/server.h \
  src/server/db_dispatcher.h \
  src/server/dispatcher.h \
  src/server/thread.h \
  src/util/queue.h \
  src/util/lock.h \
  src/server/server.h \
  src/server/db_server.h \
  src/db/recovery.h \
  src/replication/replication.h \
  src/binlog/binlog.h \
  src/db/db_define.h \
  src/util/slice.h \
  src/util/network.h \
  src/inc/module.h \
  src/util/slice.h \
  src/util/stat.h \
  src/util/lock.h \
  src/util/config_file.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/db/storeframework-partial_env.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/db/storeframework-partial_env.o src/db/env.cpp

src/db/storeframework-partial_recovery.o:src/db/recovery.cpp \
  src/db/recovery.h \
  src/db/db_define.h \
  src/util/zmalloc.h \
  src/inc/module.h \
  src/binlog/binlog.h \
  src/binlog/big_file.h \
  src/util/lock.h \
  src/util/store_define.h \
  src/util/log.h \
  src/util/log.h \
  src/inc/module.h \
  src/db/db.h \
  src/util/key_lock.h \
  src/util/hash.h \
  src/util/slice.h \
  src/util/status.h \
  src/db/db_define.h \
  src/engine/engine.h \
  src/util/slice.h \
  src/inc/module.h \
  src/inc/env.h \
  src/util/log.h \
  src/util/store_define.h \
  src/inc/module.h \
  src/db/request.h \
  src/util/pack.h \
  src/util/slice.h \
  src/util/store_define.h \
  src/util/stat.h \
  src/util/lock.h \
  src/util/config_file.h \
  src/util/scoped_ptr.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/db/storeframework-partial_recovery.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/db/storeframework-partial_recovery.o src/db/recovery.cpp

src/db/storeframework-partial_request.o:src/db/request.cpp \
  src/db/request.h \
  src/util/pack.h \
  src/util/slice.h \
  src/util/store_define.h \
  src/util/log.h \
  src/db/db_define.h \
  src/util/zmalloc.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/db/storeframework-partial_request.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/db/storeframework-partial_request.o src/db/request.cpp

src/db/storeframework-partial_response.o:src/db/response.cpp \
  src/db/response.h \
  src/util/pack.h \
  src/util/nshead.h \
  src/db/db_define.h \
  src/util/zmalloc.h \
  src/util/log.h \
  src/util/slice.h \
  src/util/zmalloc.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/db/storeframework-partial_response.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/db/storeframework-partial_response.o src/db/response.cpp

src/binlog/storeframework-partial_big_file.o:src/binlog/big_file.cpp \
  src/binlog/big_file.h \
  src/util/lock.h \
  src/util/store_define.h \
  src/util/log.h \
  src/util/log.h \
  src/util/log.h \
  src/util/file.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/binlog/storeframework-partial_big_file.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/binlog/storeframework-partial_big_file.o src/binlog/big_file.cpp

src/binlog/storeframework-partial_binlog.o:src/binlog/binlog.cpp \
  src/binlog/binlog.h \
  src/binlog/big_file.h \
  src/util/lock.h \
  src/util/store_define.h \
  src/util/log.h \
  src/util/log.h \
  src/inc/module.h \
  src/util/log.h \
  src/util/crc32c.h \
  src/util/zmalloc.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/binlog/storeframework-partial_binlog.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/binlog/storeframework-partial_binlog.o src/binlog/binlog.cpp

src/util/storeframework-partial_config_file.o:src/util/config_file.cpp \
  src/util/config_file.h \
  src/util/utils.h \
  src/util/sds.h \
  src/util/zmalloc.h \
  src/util/log.h \
  deps/new-config/config.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/util/storeframework-partial_config_file.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/util/storeframework-partial_config_file.o src/util/config_file.cpp

src/util/storeframework-partial_crc32c.o:src/util/crc32c.cpp \
  src/util/crc32c.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/util/storeframework-partial_crc32c.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/util/storeframework-partial_crc32c.o src/util/crc32c.cpp

src/util/storeframework-partial_file.o:src/util/file.cpp \
  src/util/file.h \
  src/util/log.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/util/storeframework-partial_file.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/util/storeframework-partial_file.o src/util/file.cpp

src/util/storeframework-partial_key_lock.o:src/util/key_lock.cpp \
  src/util/key_lock.h \
  src/util/hash.h \
  src/util/slice.h \
  src/util/store_define.h \
  src/util/log.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/util/storeframework-partial_key_lock.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/util/storeframework-partial_key_lock.o src/util/key_lock.cpp

src/util/storeframework-partial_log.o:src/util/log.cpp \
  src/util/url_snprintf.h \
  src/util/zmalloc.h \
  src/server/event.h \
  src/util/queue.h \
  src/util/def.h \
  src/util/log.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/util/storeframework-partial_log.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/util/storeframework-partial_log.o src/util/log.cpp

src/util/storeframework-partial_network.o:src/util/network.cpp \
  src/util/log.h \
  src/util/network.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/util/storeframework-partial_network.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/util/storeframework-partial_network.o src/util/network.cpp

src/util/storeframework-partial_pack.o:src/util/pack.cpp \
  src/util/pack.h \
  src/util/log.h \
  src/util/slice.h \
  src/util/zmalloc.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/util/storeframework-partial_pack.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/util/storeframework-partial_pack.o src/util/pack.cpp

src/util/storeframework-partial_sds.o:src/util/sds.cpp \
  src/util/sds.h \
  src/util/zmalloc.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/util/storeframework-partial_sds.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/util/storeframework-partial_sds.o src/util/sds.cpp

src/util/storeframework-partial_stat.o:src/util/stat.cpp \
  src/util/stat.h \
  src/util/lock.h \
  src/util/store_define.h \
  src/util/log.h \
  src/util/log.h \
  src/util/store_define.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/util/storeframework-partial_stat.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/util/storeframework-partial_stat.o src/util/stat.cpp

src/util/storeframework-partial_status.o:src/util/status.cpp \
  src/util/status.h \
  src/util/slice.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/util/storeframework-partial_status.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/util/storeframework-partial_status.o src/util/status.cpp

src/util/storeframework-partial_string.o:src/util/string.cpp \
  src/util/string.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/util/storeframework-partial_string.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/util/storeframework-partial_string.o src/util/string.cpp

src/util/storeframework-partial_url_snprintf.o:src/util/url_snprintf.cpp \
  src/util/url_snprintf.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/util/storeframework-partial_url_snprintf.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/util/storeframework-partial_url_snprintf.o src/util/url_snprintf.cpp

src/util/storeframework-partial_utils.o:src/util/utils.cpp \
  src/util/utils.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/util/storeframework-partial_utils.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/util/storeframework-partial_utils.o src/util/utils.cpp

src/util/storeframework-partial_zmalloc.o:src/util/zmalloc.cpp \
  src/util/zmalloc_define.h \
  src/util/zmalloc.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/util/storeframework-partial_zmalloc.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/util/storeframework-partial_zmalloc.o src/util/zmalloc.cpp

src/replication/storeframework-partial_replication.o:src/replication/replication.cpp \
  src/replication/replication.h \
  src/binlog/binlog.h \
  src/binlog/big_file.h \
  src/util/lock.h \
  src/util/store_define.h \
  src/util/log.h \
  src/util/log.h \
  src/inc/module.h \
  src/db/db_define.h \
  src/util/zmalloc.h \
  src/util/slice.h \
  src/util/network.h \
  src/inc/module.h \
  src/binlog/binlog.h \
  src/db/db.h \
  src/db/db_define.h \
  src/util/key_lock.h \
  src/util/hash.h \
  src/util/slice.h \
  src/inc/module.h \
  src/util/status.h \
  src/db/db_define.h \
  src/inc/env.h \
  src/util/log.h \
  src/util/store_define.h \
  src/inc/module.h \
  src/db/response.h \
  src/util/pack.h \
  src/util/nshead.h \
  src/server/event.h \
  src/util/queue.h \
  src/db/request.h \
  src/util/slice.h \
  src/util/store_define.h \
  src/util/pack.h \
  src/util/nshead.h \
  src/util/stat.h \
  src/util/lock.h \
  src/util/store_define.h \
  src/util/zmalloc.h \
  src/util/config_file.h \
  src/util/scoped_ptr.h \
  src/util/utils.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/replication/storeframework-partial_replication.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/replication/storeframework-partial_replication.o src/replication/replication.cpp

src/command/storeframework-partial_command.o:src/command/command.cpp \
  src/command/command.h \
  src/util/status.h \
  src/util/slice.h \
  src/util/slice.h \
  src/engine/engine.h \
  src/util/slice.h \
  src/inc/module.h \
  src/command/command_kv.h \
  src/command/command.h \
  src/command/command_list.h \
  src/command/command_stat.h \
  src/util/store_define.h \
  src/util/log.h \
  src/db/db_define.h \
  src/util/zmalloc.h \
  src/db/request.h \
  src/util/pack.h \
  src/util/slice.h \
  src/util/store_define.h \
  src/db/response.h \
  src/util/nshead.h \
  src/engine/engine.h \
  src/util/pack.h \
  src/util/slice.h \
  src/util/log.h \
  src/util/stat.h \
  src/util/lock.h \
  src/util/store_define.h \
  src/util/log.h \
  src/util/store_define.h \
  src/util/zmalloc.h \
  src/util/key_lock.h \
  src/util/hash.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/command/storeframework-partial_command.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/command/storeframework-partial_command.o src/command/command.cpp

src/command/storeframework-partial_command_kv.o:src/command/command_kv.cpp \
  src/command/command_kv.h \
  src/command/command.h \
  src/util/status.h \
  src/util/slice.h \
  src/util/slice.h \
  src/engine/engine.h \
  src/util/slice.h \
  src/inc/module.h \
  src/command/command.h \
  src/db/db_define.h \
  src/util/zmalloc.h \
  src/util/utils.h \
  src/db/request.h \
  src/util/pack.h \
  src/util/slice.h \
  src/util/store_define.h \
  src/util/log.h \
  src/engine/engine.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/command/storeframework-partial_command_kv.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/command/storeframework-partial_command_kv.o src/command/command_kv.cpp

src/command/storeframework-partial_command_list.o:src/command/command_list.cpp \
  src/command/command_list.h \
  src/command/command.h \
  src/util/status.h \
  src/util/slice.h \
  src/util/slice.h \
  src/engine/engine.h \
  src/util/slice.h \
  src/inc/module.h \
  src/command/command.h \
  src/db/db_define.h \
  src/util/zmalloc.h \
  src/util/utils.h \
  src/db/request.h \
  src/util/pack.h \
  src/util/slice.h \
  src/util/store_define.h \
  src/util/log.h \
  src/engine/engine.h \
  src/command/list.pb.h \
  deps/protobuf/src/google/protobuf/stubs/common.h \
  deps/protobuf/src/google/protobuf/generated_message_util.h \
  deps/protobuf/src/google/protobuf/message.h \
  deps/protobuf/src/google/protobuf/message_lite.h \
  deps/protobuf/src/google/protobuf/descriptor.h \
  deps/protobuf/src/google/protobuf/repeated_field.h \
  deps/protobuf/src/google/protobuf/stubs/type_traits.h \
  deps/protobuf/src/google/protobuf/stubs/template_util.h \
  deps/protobuf/src/google/protobuf/extension_set.h \
  deps/protobuf/src/google/protobuf/unknown_field_set.h \
  src/command/itemlist.h \
  src/util/slice.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/command/storeframework-partial_command_list.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/command/storeframework-partial_command_list.o src/command/command_list.cpp

src/command/storeframework-partial_command_stat.o:src/command/command_stat.cpp \
  src/command/command_stat.h \
  src/command/command.h \
  src/util/status.h \
  src/util/slice.h \
  src/util/slice.h \
  src/engine/engine.h \
  src/util/slice.h \
  src/inc/module.h \
  src/util/store_define.h \
  src/util/log.h \
  src/server/event.h \
  src/util/queue.h \
  src/binlog/binlog.h \
  src/binlog/big_file.h \
  src/util/lock.h \
  src/util/store_define.h \
  src/util/log.h \
  src/inc/module.h \
  src/db/db_define.h \
  src/util/zmalloc.h \
  src/util/log.h \
  src/util/stat.h \
  src/util/lock.h \
  src/util/store_define.h \
  src/util/pack.h \
  src/util/string.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/command/storeframework-partial_command_stat.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/command/storeframework-partial_command_stat.o src/command/command_stat.cpp

src/command/storeframework-partial_list.pb.o:src/command/list.pb.cc \
  src/command/list.pb.h \
  deps/protobuf/src/google/protobuf/stubs/common.h \
  deps/protobuf/src/google/protobuf/generated_message_util.h \
  deps/protobuf/src/google/protobuf/message.h \
  deps/protobuf/src/google/protobuf/message_lite.h \
  deps/protobuf/src/google/protobuf/descriptor.h \
  deps/protobuf/src/google/protobuf/repeated_field.h \
  deps/protobuf/src/google/protobuf/stubs/type_traits.h \
  deps/protobuf/src/google/protobuf/stubs/template_util.h \
  deps/protobuf/src/google/protobuf/extension_set.h \
  deps/protobuf/src/google/protobuf/unknown_field_set.h \
  deps/protobuf/src/google/protobuf/stubs/once.h \
  deps/protobuf/src/google/protobuf/stubs/atomicops.h \
  deps/protobuf/src/google/protobuf/stubs/platform_macros.h \
  deps/protobuf/src/google/protobuf/stubs/atomicops_internals_x86_gcc.h \
  deps/protobuf/src/google/protobuf/io/coded_stream.h \
  deps/protobuf/src/google/protobuf/wire_format_lite_inl.h \
  deps/protobuf/src/google/protobuf/wire_format_lite.h \
  deps/protobuf/src/google/protobuf/generated_message_reflection.h \
  deps/protobuf/src/google/protobuf/generated_enum_reflection.h \
  deps/protobuf/src/google/protobuf/reflection_ops.h \
  deps/protobuf/src/google/protobuf/wire_format.h \
  deps/protobuf/src/google/protobuf/descriptor.pb.h
	@echo "[[1;32;40mBUILDMAKE:BUILD[0m][Target:'[1;31;40msrc/command/storeframework-partial_list.pb.o[0m']"
	$(CXX) -c $(INCPATH) $(DEP_INCPATH) $(CPPFLAGS) $(CXXFLAGS)  -o src/command/storeframework-partial_list.pb.o src/command/list.pb.cc

endif #ifeq ($(shell uname -m), x86_64)

