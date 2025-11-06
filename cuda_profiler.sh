# 编译程序
nvcc -o my_program my_program.cu -lineinfo

# 运行性能分析
nsys profile -o output_report ./my_program

# 查看报告(GUI)
nsys-ui output_report.qdrep


# 完整分析(所有指标)
ncu --set full -o detailed ./my_program

# 快速分析
ncu --set basic -o quick ./my_program

# 分析特定 kernel
ncu --kernel-name myKernel -o specific ./my_program

# 只分析第一次调用
ncu --launch-skip 0 --launch-count 1 ./my_program

# 分析多个 kernel 调用
ncu --kernel-id ::myKernel:2 ./my_program  # 第3次调用(从0开始)

# 指定分析指标
ncu --metrics sm__throughput.avg.pct_of_peak_sustained_elapsed \
    --metrics dram__throughput.avg.pct_of_peak_sustained_elapsed \
    -o metrics ./my_program

# 生成基线对比
ncu --set full --import-source yes -o baseline ./my_program_v1
ncu --set full --import-source yes -o optimized ./my_program_v2

# 直接在终端显示结果
ncu --set basic ./my_program

# 输出为 CSV
ncu --csv --metrics sm_efficiency,achieved_occupancy ./my_program

# 查看可用的指标
ncu --query-metrics

# 查看可用的规则集
ncu --list-sets



# 1. 编译
nvcc -o vector_add vector_add.cu -lnvToolsExt -lineinfo

# 2. 系统级分析(查看整体性能)
nsys profile --trace=cuda,nvtx --stats=true -o system_view ./vector_add

# 3. Kernel 级详细分析
ncu --set full -o kernel_detail ./vector_add

# 4. 查看报告
nsys-ui system_view.qdrep &
ncu-ui kernel_detail.ncu-rep &
