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
csvdata = pd.read_csv('twosite.csv')
time = csvdata['time']
h1 = Pbase*csvdata['power']
h2 = Qbase*csvdata['heatflow']
h3 = pbase*csvdata['pressure']/1000 + 800

## regulation signal
import numpy as np
#pref = (1 + 0.1*np.sin(2*np.pi*time/30))*Pbase

regd = pd.read_csv('reg-d.CSV')
def regd_at_t(t):
    if t<0:
        return 0
    else:
        sig = regd.RegDTest[int(t/2)]
        return sig
regd_profile = np.array([regd_at_t(t) for t in time])
pref = (1.0 + 0.2*regd_profile)*Pbase



# pltを初期化
# (この例では不必要.同じスクリプトで複数の図を作成する場合などに使用.)
plt.clf()

plt.figure(figsize=(5,5))
plotNum = 3;
xlim=(0,2400)

##プロット１　##########################
# plt.subplot(plotNum,1,1)
# # データのプロット
# plt.plot(time, v1,  label='$v_1$',  zorder=3, ls='-',  lw=2, c='b')
# plt.plot(time, v2,  label='$v_2$',  zorder=2, ls='-',  lw=2, c='g')
# # 軸ラベルの設定
# plt.ylabel('Input $v_j$ [p.u.]',fontsize=10)
# # x軸とy軸の設定
# plt.xlim(xlim)
# plt.ylim(-10,10)
# plt.xticks(fontsize=12)
# plt.yticks(fontsize=12)
# plt.tick_params(direction='in', width=1, length=3, labelbottom=False, top=True)
# plt.legend(loc='right', bbox_to_anchor=(1.2,0.7), #凡例の位置
#            frameon=False, #凡例の囲みは不必要
#            fontsize=12, #凡例のフォントサイズ
#            handlelength = 1,
#            ncol=1, labelspacing=0.2 #凡例の並び方
#            )

## 電力　##########################
plt.subplot(plotNum,1,1)
# データのプロット
plt.plot(time, h1, label='$y_1$', zorder=2, ls='-', lw=2, c='r')
#plt.plot(time, ref1,  label='$y_1^\mathrm{ref}$',  zorder=1, ls='-',  lw=2, c='g')
plt.plot(time, pref,  label='$Y_1^\mathrm{as}$',  zorder=3, ls=':',  lw=2, c='k')
# 軸ラベルの設定
plt.ylabel('Power [MW]',fontsize=10,labelpad=14)
# x軸とy軸の設定
plt.xlim(xlim)
plt.ylim(3.5,6.5)
plt.xticks(fontsize=12)
plt.yticks(np.arange(4, 6.1, step=0.5), fontsize=12)
plt.tick_params(direction='in', width=1, length=3, labelbottom=False, top=True)
plt.legend(loc='right', bbox_to_anchor=(1.23,0.5), #凡例の位置
           frameon=False, #凡例の囲みは不必要
           fontsize=12, #凡例のフォントサイズ
           handlelength = 1.0,
           ncol=1, labelspacing=0.2 #凡例の並び方
           )

## 熱流　##########################
plt.subplot(plotNum,1,2)
# データのプロット 
plt.plot(time, h2, label='h2', zorder=1, ls='-', lw=2, c='r')
plt.axhline(y=1.69, ls='--', lw=2, c='k', zorder=-1)
# x軸とy軸のラベルを設定します
plt.ylabel('Heat Flow [MJ/s]',fontsize=10, labelpad=15)
# x軸とy軸のプロット範囲を設定します
plt.xlim(xlim)
plt.ylim(1.6, 1.8)
# x軸とy軸の目盛りを設定を設定します
plt.xticks(fontsize=12)
#plt.yticks(np.arange(3.0, 8.1, step=1.0), fontsize=12)
plt.tick_params(direction='in', width=1, length=3, labelbottom=False, top=True)


## 圧力　##########################
plt.subplot(plotNum,1,3)
# データのプロット 
plt.plot(time, h3, label='$y_2$', zorder=3, ls='-', lw=2, c='r')
#plt.plot(time, ref2, label='$y_2^\mathrm{ref}$', zorder=2, ls='-', lw=2, c='g')
# 水平線
#plt.axhline(y=60/31.25, ls='--', lw=3, c='r', zorder=-1)
#plt.axhline(y=60/31.25/3, c='r')
# x軸とy軸のラベルを設定します
#plt.xlabel('')
plt.xlabel('Time [s]', fontsize=12)
plt.ylabel('Pressure [kPa]',fontsize=10, labelpad=10)
# x軸とy軸のプロット範囲を設定します
plt.xlim(xlim)
plt.ylim(780,860)
# x軸とy軸の目盛りを設定を設定します
plt.xticks(fontsize=12)
plt.yticks(fontsize=12)
plt.legend(loc='right', bbox_to_anchor=(1.23,0.6), #凡例の位置
           frameon=False, #凡例の囲みは不必要
           fontsize=12, #凡例のフォントサイズ
           handlelength = 1.0,
           ncol=1, labelspacing=0.2 #凡例の並び方
           )
plt.tick_params(direction='in', width=1, length=3, top=True)


# グラフの周囲の余白をゼロに設定します
plt.margins(0)

# グラフを出力します
plt.savefig('twosite.pdf', bbox_inches="tight")
