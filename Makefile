################################################################################
# Copyright (c) 2019, NVIDIA CORPORATION. All rights reserved.
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#  * Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#  * Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#  * Neither the name of NVIDIA CORPORATION nor the names of its
#    contributors may be used to endorse or promote products derived
#    from this software without specific prior written permission.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ``AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
# OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################
#
# Makefile project only supported on Mac OS X and Linux Platforms
#
################################################################################

# Define the compiler and flags
NVCC = /usr/local/cuda/bin/nvcc
CXX = g++
CXXFLAGS = -std=c++17 -I/usr/local/cuda/include -Iinclude -I/usr/local/include -I./lib
NVCCFLAGS = -arch=sm_75
LDFLAGS = -L/usr/local/cuda/lib64 -L/usr/local/lib -lcudart -lnppc -lnppicc -lnppig -lcufft -lcusolver /usr/local/lib/libAquila.a

# Define directories
SRC_DIR = src
PROC_DIR = $(SRC_DIR)/proc
BIN_DIR = bin
DATA_DIR = data
LIB_DIR = lib

# Define source files and target executable
PROC_SRC = $(PROC_DIR)/wav_loader.cu $(PROC_DIR)/feature_extraction.cu $(PROC_DIR)/pca.cu
MAIN_SRC = $(SRC_DIR)/main.cu
TARGET = $(BIN_DIR)/signalPCA_NPP.exe

# Define the default rule
all: $(TARGET)

# Rule for building the target executable
$(TARGET): $(PROC_SRC) $(MAIN_SRC)
	mkdir -p $(BIN_DIR)
	$(NVCC) $(CXXFLAGS) $(NVCCFLAGS) $(PROC_SRC) $(MAIN_SRC) -o $(TARGET) $(LDFLAGS)

# Rule for running the application
run: $(TARGET)
	./$(TARGET) --input $(DATA_DIR)/WAV_files --output $(DATA_DIR)/pca_result.txt

# Clean up
clean:
	rm -rf $(BIN_DIR)/* results/eigenvalues.csv results/features_with_labels.csv results/pca_results.csv || true

# Installation rule (not much to install, but here for completeness)
install:
	@echo "No installation required."

# Help command
help:
	@echo "Available make commands:"
	@echo "  make        - Build the project."
	@echo "  make run    - Run the project."
	@echo "  make clean  - Clean up the build files."
	@echo "  make install- Install the project (if applicable)."
	@echo "  make help   - Display this help message."
