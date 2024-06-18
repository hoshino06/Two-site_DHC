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
csvdata = pd.read_csv('simex3_without_const_outputs.csv')
time_case2 = csvdata['time']
h1_case2 = Pbase*csvdata['power']
h2_case2 = Qbase*csvdata['heatflow']
h3_case2 = pbase*csvdata['pressure']/1000 + 780

csvdata = pd.read_csv('simex3_with_const_outputs.csv')
time_case3 = csvdata['time']
h1_case3 = Pbase*csvdata['power']
h2_case3 = Qbase*csvdata['heatflow']    
h3_case3 = pbase*csvdata['pressure']/1000 + 780

## regulation signal
import numpy as np
regd = pd.read_csv('reg-d.CSV')
def regd_at_t(t):
    if t<0:
        return 0
    else:
        sig = regd.RegDTest[int(t/2)]
        return sig
regd_profile = np.array([regd_at_t(t) for t in time_case2])
pref1 = (1.0 + 0.2*regd_profile)*Pbase
pref2 = (1.0 + 0.4*regd_profile)*Pbase

# pltを初期化
# (この例では不必要.同じスクリプトで複数の図を作成する場合などに使用.)
plt.clf()

plt.figure(figsize=(5,5))
plotNum = 3;
xlim=(0,2400)

## 電力　##########################
plt.subplot(plotNum,1,1)
# データのプロット
#plt.plot(time_case1, h1_case1,    label='$Y_1^\mathrm{AS}=0$', zorder=2, ls='-', lw=1.5, c='r')
plt.plot(time_case2, h1_case2, label='w/o input const.', zorder=2, ls='-', lw=1.5, c='b')
plt.plot(time_case3, h1_case3, label='w/  input const.', zorder=2, ls='-', lw=1.5, c='g')
plt.plot(time_case2, pref2,  label='reference',  zorder=3, ls=':',  lw=2, c='r')
#plt.plot(time_case1, pref1,  label='',  zorder=3, ls=':',  lw=2, c='k')
# 軸ラベルの設定
plt.ylabel('Power [MW]',fontsize=10,labelpad=10)
# x軸とy軸の設定
plt.xlim(xlim)
plt.ylim(0.0,8.0)
plt.xticks(np.arange(0, 2400+0.1, step=300.0), fontsize=10)
plt.yticks(np.arange(0.0, 8.0+0.01, step=2.0), fontsize=10)
plt.tick_params(direction='in', width=1, length=3, labelbottom=False, top=True,right=True)
plt.gca().yaxis.set_major_formatter(plt.FormatStrFormatter('%.1f'))#y軸小数点以下3桁表示
plt.legend(loc='lower right', #bbox_to_anchor=(1.0,1.0), #凡例の位置
           frameon=True, #凡例の囲みは不必要
           fontsize=7, #凡例のフォントサイズ
           handlelength = 1.2,
           ncol=1, labelspacing=0.1 #凡例の並び方
           )

## 熱流　##########################
plt.subplot(plotNum,1,2)
# データのプロット 
#plt.plot(time_case1, h2_case1, label='h2', zorder=1, ls='-', lw=1.5, c='r')
plt.plot(time_case2, h2_case2, label='w/o pressure const.', zorder=1, ls='-', lw=1.5, c='b')
plt.plot(time_case3, h2_case3, label='w/ pressure const.', zorder=1, ls='-', lw=1.5, c='g')
plt.axhline(y=1.69, ls=':', label='reference', lw=2, c='k', zorder=3)
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
# plt.legend(loc='upper right', #bbox_to_anchor=(1.0,1.0), #凡例の位置
#            frameon=True, #凡例の囲みは不必要
#            fontsize=7, #凡例のフォントサイズ
#            handlelength = 1.2,
#            ncol=1, labelspacing=0.1 #凡例の並び方
#            )

## 圧力　##########################
plt.subplot(plotNum,1,3)
# データのプロット 
#plt.plot(time_case1, h3_case1, label='', zorder=3, ls='-', lw=1.5, c='r')
plt.plot(time_case2, h3_case2, label='', zorder=3, ls='-', lw=1.5, c='b')
plt.plot(time_case3, h3_case3, label='', zorder=3, ls='-', lw=1.5, c='g')
# 水平線
plt.axhline(y=830, ls='--', lw=1, c='k', zorder=-1)
plt.axhline(y=730, ls='--', lw=1, c='k', zorder=-1)
# x軸とy軸のラベルを設定します
#plt.xlabel('')
plt.xlabel('Time [s]', fontsize=10)
plt.ylabel('Pressure [kPa]',fontsize=10, labelpad=10)
# x軸とy軸のプロット範囲を設定します
plt.xlim(xlim)
plt.ylim(700,900)
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
plt.savefig('simex3_comparison_outputs.pdf', bbox_inches="tight")
plt.show()


### 入力 ##############################################################################################
plt.clf()
plt.figure(figsize=(5,2.8))
plotNum = 2;
xlim=(0,2400)

csvdata = pd.read_csv('simex3_with_const_inputs_etc.csv')
time = csvdata['time']
in1 = csvdata['in1']
in2 = csvdata['in2']

csvdata = pd.read_csv('simex3_without_const_inputs_etc.csv')
time_wo = csvdata['time']
in1_wo = csvdata['in1']
in2_wo = csvdata['in2']

## 入力1　##########################
plt.subplot(plotNum,1,1)

plt.plot(time_wo, in1_wo, label='w/o input const', zorder=3, ls='-', lw=1.5, c='b')
plt.plot(time, in1, label='w/ input const', zorder=3, ls='-', lw=1.5, c='g')
# 水平線
plt.axhline(y=0.6, ls='--', lw=1, c='k', zorder=-1)
# x軸とy軸のラベルを設定します
plt.xlabel('')
#plt.xlabel('Time [s]', fontsize=10)
plt.ylabel('Input 1 [pu]',fontsize=10, labelpad=10)
# x軸とy軸のプロット範囲を設定します
plt.xlim(xlim)
plt.ylim(0,1)
# x軸とy軸の目盛りを設定を設定します
plt.xticks(np.arange(0, 2400+0.1, step=300.0), fontsize=10)
plt.yticks(fontsize=10)
plt.tick_params(direction='in', width=1, length=3, labelbottom=False, top=True, right=True)
plt.legend(loc='lower right', #bbox_to_anchor=(1.0,1.0), #凡例の位置
           frameon=True, #凡例の囲みは不必要
           fontsize=7, #凡例のフォントサイズ
           handlelength = 1.2,
           ncol=1, labelspacing=0.1 #凡例の並び方
           )

## 入力2　##########################
plt.subplot(plotNum,1,2)

plt.plot(time_wo, in2_wo, label='input 1', zorder=3, ls='-', lw=1.5, c='b')
plt.plot(time, in2, label='input 2', zorder=3, ls='-', lw=1.5, c='g')
# 水平線
# x軸とy軸のラベルを設定します
#plt.xlabel('')
plt.xlabel('Time [s]', fontsize=10)
plt.ylabel('Input 2 [pu]',fontsize=10, labelpad=10)
# x軸とy軸のプロット範囲を設定します
plt.xlim(xlim)
plt.ylim(0,1)
# x軸とy軸の目盛りを設定を設定します
plt.xticks(np.arange(0, 2400+0.1, step=300.0), fontsize=10)

plt.yticks(fontsize=10)
plt.tick_params(direction='in', width=1, length=3, top=True, right=True)
# plt.legend(loc='lower right', #bbox_to_anchor=(1.0,1.0), #凡例の位置
#            frameon=True, #凡例の囲みは不必要
#            fontsize=7, #凡例のフォントサイズ
#            handlelength = 1.2,
#            ncol=1, labelspacing=0.1 #凡例の並び方
#            )




# グラフの周囲の余白をゼロに設定します
plt.margins(0)
plt.savefig('simex3_comparison_inputs.pdf', bbox_inches="tight")
plt.show()


         