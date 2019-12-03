# T-DLA

T-DLA (Ternarized Deep Learning Accelerator) is an open-source accelerator designed specifically for accelerating DNN models trained with ternarized weights. This is the first instruction-based DLA design targeting ternary-quantized weights. The T-DLA system delivers up to 0.4 TOPS with 2.58 W power consumption. It is 873.6× and 5.1× faster on ImageNet for Resnet-18 model comparing to Xeon E5-2630 CPU and Nvidia 1080 Ti GPU respectively.

## Details of the Repo

### t_dla_ip
The IP design contains the components to construct the T-DLA accelerator.

### t_dla_sys
The accelerator system design is constructed by the accelerator IP and the ARM core in the FPGA chip. The corresponding software developed with the vivado SDK is included.

### Quantization
The ternary quantization in this work has been merged into a complete version with controlable bitwidth quantization and integrated into Caffe training flow, please refer to:
https://github.com/microideax/Quantization-caffe
The corresponding publication is:
```
@article{cheng2019uL2Q,
  title={$\mu$L2Q: An Ultra-Low Loss Quantization Method for DNN},
  author={Cheng, Gong and Ye, Lu and Tao, Li and Xiaofan, Zhang and Cong, Hao and Deming, Chen and Yao, Chen},
  journal={The 2019 International Joint Conference on Neural Networks (IJCNN)},
  year={2019}
}
```

# Corresponding Publication
If you wish to cite our work, please use the following citation:
```
@article{yao2019tdla,
  title={T-DLA: An Open-source Deep Learning Accelerator for Ternarized DNN Models on Embedded FPGA},
  author={Yao Chen, Kai Zhang, Cheng Gong, Cong Hao, Xiaofan Zhang, Tao Li and Deming Chen},
  journal={IEEE Computer Society Annual Symposium on VLSI 2019 (ISVLSI)},
  year={2019}
}
```
