# Fast-llama-alpaca：一键部署中文LLaMA&Alpaca大语言模型

本项目旨在对国内**[Chinese-LLaMA-Alpaca](https://link.zhihu.com/?target=https%3A//github.com/ymcui/Chinese-LLaMA-Alpaca)**开源项目的各个步骤进行整合优化，从而快速完成从原始LLaMA模型词表扩展、模型预训练和模型指令精调的整个过程。对各个步骤的详细解释可以参考https://zhuanlan.zhihu.com/p/631360711



首先安装需要的依赖并拉取相关项目、下载LLaMA原始模型：

```shell
git clone git@github.com:ZeBraHack0/Fast-llama-alpaca-zh.git
cd Fast-llama-alpaca-zh/script/train
bash train.sh setup
```
需要注意的是，如果已经下载好模型，可以注释掉脚本中的下载部分，并将模型文件软连接到项目目录下

然后将中文词表与LLaMA原始词表进行合并：

```shell
bash train.sh merge token
```

开始对lora模型进行预训练：这里我们使用开源书籍作为训练数据，本项目提供清洗过后的数据版本，原始数据见https://github.com/shjwudp/shu/tree/master

```shell
bash train.sh pretrain
```

若遇到报错“ModuleNotFoundError:No module named 'torch._six'”，可参考https://blog.csdn.net/qq_24502827/article/details/130195645进行解决

训练完成后对lora模型与原始LLaMA模型进行合并：

```shell
bash train.sh merge lora_pt
```

接下来进行指令精调：这里我们使用网上开源的公开中文指令数据集（标准**[Stanford Alpaca](https://link.zhihu.com/?target=https%3A//github.com/tatsu-lab/stanford_alpaca)**格式），原始数据见https://github.com/hikariming/alpaca_chinese_dataset

```shell
bash train.sh finetune
```

精调后再将lora模型合并到原始LLaMA模型

```shell
bash train.sh merge lora_sft
```

最后可以调用精调后的模型进行简单测试：

```shell
bash train.sh inference
```

