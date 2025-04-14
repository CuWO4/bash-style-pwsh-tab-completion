# BASH-STYLE 的 POWERSHELL TAB 补全

---

## 效果

![example](doc/pic/example.png)

## 特点

- bash 风格的补全, 补全到候选项的最长公共前缀. 若无法继续补全, 则打印候选项.

- 除命令首部, 自动在恰当的情况下添加 `.\` 前缀使得仅补全工作目录文件, 而不会被 Powershell 内置命令/环境变量干扰.

## 使用

```pwsh
./install.ps1 # 如果失败, 请以管理员身份运行
```

, 重启生效.

安装后, 配置 `PWSH_TAB_COMPLETION` 环境变量为 `CIRCULATION` 或 `BASH_STYLE` 即可相应改变补全模式, 重启 pwsh 生效.

使用

```pwsh
./uninstall.ps1
```

卸载, 重启生效.

## 细节解释

工具通过自动添加 `.\` 前缀来保证仅补全当前工作目录中的文件. 目前工具可以识别

1. 以`./`, `../`, `.\`, `..\`, `/`, `\`, `//`, `\\`, `~/`, `~\` 或盘符开头;
1. 在引号环境中

两种情况不添加 `.\`.

`install.sh` 将 `profile.sh` 写入到 `$PROFILE` 中, 如果不存在就先创建一个. `$PROFILE` 是 Powershell 的配置文件, 会在每次启动时执行.
