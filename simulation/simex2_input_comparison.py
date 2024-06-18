# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 13:52:17 2019

@author: hoshino
"""
# matplotlibのpyplotモジュールを読み込み
import matplotlib.pyplot as plt
#plt.rcParams['text.usetex'] = True

# プロットするデータを準備
Pbase = 5.0
Qbase = 1.0
pbase = 4062.5
vbase = 31.25

import pandas as pd

csvdata = pd.read_csv('simex1_weightQh0p001.csv')
time_case1 = csvdata['time']
h1_case1 = Pbase*csvdata['power']
h2_case1 = Qbase*csvdata['heatflow']
h3_case1 = pbase*csvdata['pressure']/1000 + 800
in1_case1 = csvdata['in1']
in2_case1 = csvdata['in2']

csvdata = pd.read_csv('simex2_inputQh0p001.csv')
time_case3 = csvdata['time']
h1_case3 = Pbase*csvdata['power']
h2_case3 = Qbase*csvdata['heatflow']
h3_case3 = pbase*csvdata['pressure']/1000 + 800
in1_case3 = csvdata['in1']
in2_case3 = csvdata['in2']



## regulation signal
import numpy as np
regd = pd.read_csv('reg-d.CSV')
def regd_at_t(t):
    if t<0:
        return 0
    else:
        sig = regd.RegDTest[int(t/2)]
        return sig
regd_profile = np.array([regd_at_t(t) for t in time_case1])
pref = (1.0 + 0.4*regd_profile)*Pbase



# pltを初期化
# (この例では不必要.同じスクリプトで複数の図を作成する場合などに使用.)
plt.clf()

plt.figure(figsize=(5,7.5))
plotNum = 5;
xlim=(0,2400)


## 電力　##########################
plt.subplot(plotNum,1,1)
# データのプロット
plt.plot(time_case1, pref,  label='',  zorder=3, ls=':',  lw=2, c='k')
plt.plot(time_case1, h1_case1,    label='$u_1 \leq 1.0$', zorder=2, ls='-', lw=1.5, c='g')
#plt.plot(time_case2, h1_case2,    label='$Q_\mathrm{h1}=0.10$', zorder=2, ls='-', lw=1.5, c='g')
plt.plot(time_case3, h1_case3,    label='$u_1 \leq 0.6 $', zorder=2, ls='-', lw=1.5, c='b')
# 軸ラベルの設定
plt.ylabel('Power [MW]',fontsize=10,labelpad=10)
# x軸とy軸の設定
plt.xlim(xlim)
plt.ylim(2.0,8.0)
plt.xticks(np.arange(0, 2400+0.1, step=300.0), fontsize=10)
plt.yticks(np.arange(2.0, 8.0+0.01, step=2.0), fontsize=10)
plt.tick_params(direction='in', width=1, length=3, labelbottom=False, top=True,right=True)
plt.gca().yaxis.set_major_formatter(plt.FormatStrFormatter('%.1f'))#y軸小数点以下3桁表示
plt.legend(loc='upper left', bbox_to_anchor=(1.0,1.0), #凡例の位置
           frameon=False, #凡例の囲みは不必要
           fontsize=10, #凡例のフォントサイズ
           handlelength = 1.0,
           ncol=1, labelspacing=0.2 #凡例の並び方
           )

## 熱流　##########################
plt.subplot(plotNum,1,2)
# データのプロット 
plt.plot(time_case1, h2_case1, label='h2', zorder=1, ls='-', lw=1.5, c='g')
#plt.plot(time_case2, h2_case2, label='h2', zorder=1, ls='-', lw=1.5, c='g')
plt.plot(time_case3, h2_case3, label='h2', zorder=1, ls='-', lw=1.5, c='b')
plt.axhline(y=1.69, ls=':', lw=2, c='k', zorder=3)
# x軸とy軸のラベルを設定します
plt.ylabel('Heat Flow [MJ/s]',fontsize=10, labelpad=10)
# x軸とy軸のプロット範囲を設定します
plt.xlim(xlim)
plt.ylim(-1.0, 4.0)
# x軸とy軸の目盛りを設定を設定します
plt.xticks(np.arange(0, 2400+0.1, step=300.0), fontsize=10)
plt.yticks(np.arange(-1.0, 4.1, step=1.0), fontsize=10)
plt.tick_params(direction='in', width=1, length=3, labelbottom=False, top=True, right=True)
plt.gca().yaxis.set_major_formatter(plt.FormatStrFormatter('%.1f'))#y軸小数点以下3桁表示


## 圧力　##########################
plt.subplot(plotNum,1,3)
# データのプロット 
plt.plot(time_case1, h3_case1, label='', zorder=3, ls='-', lw=1.5, c='g')
#plt.plot(time_case2, h3_case2, label='', zorder=3, ls='-', lw=1.5, c='g')
plt.plot(time_case3, h3_case3, label='', zorder=3, ls='-', lw=1.5, c='b')
# 水平線
plt.axhline(y=850, ls='--', lw=1, c='k', zorder=-1)
plt.axhline(y=750, ls='--', lw=1, c='k', zorder=-1)
# x軸とy軸のラベルを設定します
#plt.xlabel('')
#plt.xlabel('Time [s]', fontsize=10)
plt.ylabel('Pressure [kPa]',fontsize=10, labelpad=10)
# x軸とy軸のプロット範囲を設定します
plt.xlim(xlim)
plt.ylim(740,860)
# x軸とy軸の目盛りを設定を設定します
plt.xticks(np.arange(0, 2400+0.1, step=300.0), fontsize=10)
plt.yticks(fontsize=10)
# plt.legend(loc='right', bbox_to_anchor=(1.23,0.6), #凡例の位置
#            frameon=False, #凡例の囲みは不必要
#            fontsize=12, #凡例のフォントサイズ
#            handlelength = 1.0,
#            ncol=1, labelspacing=0.2 #凡例の並び方
#            )
plt.tick_params(direction='in', width=1, length=3, labelbottom=False, top=True, right=True)


## 入力　##########################
plt.subplot(plotNum,1,4)
# データのプロット 
plt.plot(time_case1, in1_case1, label='', zorder=2, ls='-', lw=1.5, c='g')
#plt.plot(time_case2, in1_case2, label='', zorder=2, ls='-', lw=1.5, c='g')
plt.plot(time_case3, in1_case3, label='', zorder=2, ls='-', lw=1.5, c='b')

# 水平線
plt.axhline(y=0.6, ls='--', lw=1, c='k', zorder=-1)
# x軸とy軸のラベルを設定します
#plt.xlabel('')
#plt.xlabel('Time [s]', fontsize=10)
plt.ylabel('Input 1 [p.u.]',fontsize=10, labelpad=10)
# x軸とy軸のプロット範囲を設定します
plt.xlim(xlim)
plt.ylim(0,1)
# x軸とy軸の目盛りを設定を設定します
plt.xticks(np.arange(0, 2400+0.1, step=300.0), fontsize=10)

plt.yticks(fontsize=10)
# plt.legend(loc='right', bbox_to_anchor=(1.23,0.6), #凡例の位置
#            frameon=False, #凡例の囲みは不必要
#            fontsize=12, #凡例のフォントサイズ
#            handlelength = 1.0,
#            ncol=1, labelspacing=0.2 #凡例の並び方
#            )
plt.tick_params(direction='in', width=1, length=3, labelbottom=False, top=True, right=True)


## 入力　##########################
plt.subplot(plotNum,1,5)
# データのプロット 
plt.plot(time_case1, in2_case1, label='', zorder=3, ls='-', lw=1.5, c='g')
#plt.plot(time_case2, in2_case2, label='', zorder=3, ls='-', lw=1.5, c='g')
plt.plot(time_case3, in2_case3, label='', zorder=3, ls='-', lw=1.5, c='b')
# 水平線
#plt.axhline(y=0.6, ls='--', lw=1, c='k', zorder=-1)
# x軸とy軸のラベルを設定します
#plt.xlabel('')
plt.xlabel('Time [s]', fontsize=10)
plt.ylabel('Input 2 [p.u.]',fontsize=10, labelpad=10)
# x軸とy軸のプロット範囲を設定します
plt.xlim(xlim)
plt.ylim(0,1)
# x軸とy軸の目盛りを設定を設定します
plt.xticks(np.arange(0, 2400+0.1, step=300.0), fontsize=10)

plt.yticks(fontsize=10)
# plt.legend(loc='right', bbox_to_anchor=(1.23,0.6), #凡例の位置
#            frameon=False, #凡例の囲みは不必要
#            fontsize=12, #凡例のフォントサイズ
#            handlelength = 1.0,
#            ncol=1, labelspacing=0.2 #凡例の並び方
#            )
plt.tick_params(direction='in', width=1, length=3, top=True, right=True)


# グラフの周囲の余白をゼロに設定します
plt.margins(0)

# グラフを出力します
#plt.savefig('simex1_weight.png', bbox_inches="tight")
plt.savefig('simex2_input_comparison.pdf', bbox_inches="tight")
