# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 13:52:17 2019

@author: hoshino
"""
import matplotlib.pyplot as plt
import pandas as pd
#plt.rcParams['text.usetex'] = True フォントが変わるので注意


# プロットするデータを準備
Pbase = 5.0
Qbase = 1.0
pbase = 4062.5

csvdata = pd.read_csv('simex3_without_const_outputs.csv')
csvdata = csvdata.query('time>=0')
h1_case1 = Pbase*csvdata['power']
h2_case1 = Qbase*csvdata['heatflow']

csvdata = pd.read_csv('simex3_with_const_outputs.csv')
csvdata = csvdata.query('time>=0')
h1_case2 = Pbase*csvdata['power']
h2_case2 = Qbase*csvdata['heatflow']

eqs = pd.read_csv('simex2_equilibriums.csv', header=None, names=['power', 'heat'])
eq_power = Pbase*eqs['power']
eq_heat  = Qbase*eqs['heat']

cons = pd.read_csv('simex2_constrains.csv', header=None,
                   names=['u1minP','u1minQ','u2minP','u2minQ','u1maxP','u1maxQ','u2maxP','u2maxQ'])
cons['u1minP'] = Pbase*cons['u1minP']
cons['u2minP'] = Pbase*cons['u2minP']
cons['u1maxP'] = Pbase*cons['u1maxP']
cons['u2maxP'] = Pbase*cons['u2maxP']

# pltを初期化
# (この例では不必要.同じスクリプトで複数の図を作成する場合などに使用.)
plt.clf()
plt.figure(figsize=(5,5))

plt.plot(eq_power, eq_heat,  label='steady state', zorder=1, ls=':', lw=1.5, c='r')
plt.plot(h1_case1, h2_case1, label='w/o input const.', zorder=3, ls='-', lw=1.5, c='b')
plt.plot(h1_case2, h2_case2, label='w/ input const.', zorder=5, ls='-', lw=1.5, c='g')

plt.plot(cons['u1minP'], cons['u1minQ'],  label='', zorder=1, ls='--', lw=1.0, c='k')
plt.plot(cons['u2minP'], cons['u2minQ'],  label='', zorder=1, ls='--', lw=1.0, c='k')
plt.plot(cons['u1maxP'], cons['u1maxQ'],  label='', zorder=1, ls='--', lw=1.0, c='k')
plt.plot(cons['u2maxP'], cons['u2maxQ'],  label='', zorder=1, ls='--', lw=1.0, c='k')
plt.text(3.85, 2.95, r'$u_1 = 0.6$', rotation=-54, fontsize=10)
plt.text(1.4, 0.15, r'$u_1 = 0$', rotation=-54, fontsize=10)
plt.text(1.9, 2.18, r'$u_2 = 0$', rotation=30, fontsize=10)
plt.text(6, 0.22, r'$u_2 = 1.0$', rotation=30, fontsize=10)

plt.xlim(1,8)
plt.ylim(-0.5,3.5)
plt.xlabel('Electric Power $y_1$ [MW]', fontsize=10)
plt.ylabel('Heat Flow $y_2$ [MJ/s]',fontsize=10)

plt.legend(loc='upper left', #bbox_to_anchor=(1.0,1.0), #凡例の位置
           frameon=True, #凡例の囲みは不必要
           fontsize=8, #凡例のフォントサイズ
           handlelength = 1.5,
           ncol=1, labelspacing=0.1 #凡例の並び方
           )


plt.quiver(6.3,1.77,0.6,0, cmap='Reds', scale = 1, scale_units='xy')
plt.annotate("1'", xy=(6.8,1.85), fontsize=10)

plt.quiver(6.4,2.1,-0.1,0.3, cmap='Reds', scale = 1, scale_units='xy')
plt.annotate("2'", xy=(6.45,2.2), fontsize=10)

plt.quiver(5.3,2.4,-0.35,-0.3, cmap='Reds', scale = 1, scale_units='xy')
plt.annotate("3'", xy=(4.6,2.25), fontsize=10)


plt.quiver(6.28,1.64,0.2,-0.28, cmap='Reds', scale = 1, scale_units='xy')
plt.annotate("1", xy=(6.65,1.35), fontsize=10)

plt.quiver(5.88,1.8,-0.2,0.3, cmap='Reds', scale = 1, scale_units='xy')
plt.annotate("2", xy=(5.8,1.9), fontsize=10)

plt.quiver(5.0,1.9,-0.35,-0.15, cmap='Reds', scale = 1, scale_units='xy')
plt.annotate("3", xy=(5.03,1.9), fontsize=10)

plt.quiver(3.4,1.0,0.06,-0.3, cmap='Reds', scale = 1, scale_units='xy')
plt.annotate("4", xy=(3.1,0.75), fontsize=10)

plt.quiver(5.0,0.9,0.4,0.2, cmap='Reds', scale = 1, scale_units='xy')
plt.annotate("5", xy=(5.2,0.75), fontsize=10)


plt.annotate("A", xy=(4.95,1.45), fontsize=10)
plt.plot(5,1.686,'kx', label='',lw=1.5,  zorder=5)

plt.annotate("B", xy=(5.55,2.15), fontsize=10)
plt.plot(5.43,2.15,'kx', label='',lw=1.5,  zorder=5)


# グラフの周囲の余白をゼロに設定します
plt.margins(0)

# グラフを出力します
#plt.savefig('simex1_weight.png', bbox_inches="tight")
plt.savefig('simex3_refplane.pdf', bbox_inches="tight")
