---
layout: default
---

# **Key Switching**

## なぜ$\text{LWE}_\mathbf{s}(\Delta m)\gets (0,\dots,0,b'_0)-\Sigma^{n-1}_{i=0}\Sigma^{l-1}_{j=0}\bar{a}_{i,j}ksk[i,j]$でうまくいくのか?

以下のように変形する。

$\text{LWE}_\mathbf{s}(\Delta m)= (0,\dots,0,b'_0)-\Sigma^{n-1}_{i=0}\Sigma^{l-1}_{j=0}\bar{a}_{i,j}ksk[i,j]$

$=(0,\dots,0,b'_0)-\Sigma^{n-1}_{i=0}\Sigma^{l-1}_{j=0}\bar{a}_{i,j}\text{LWE}_\mathbf{s}(s''_iq/B^{j+1})$

$=(0,\dots,0,b'_0)-\Sigma^{n-1}_{i=0}\Sigma^{l-1}_{j=0}\text{LWE}_\mathbf{s}(\bar{a}_{i,j}s''_iq/B^{j+1})$

$=(0,\dots,0,b'_0)-\text{LWE}_\mathbf{s}(\Sigma^{n-1}_{i=0}\Sigma^{l-1}_{j=0}\bar{a}_{i,j}s''_iq/B^{j+1})$

$=(0,\dots,0,b'_0)-\text{LWE}_\mathbf{s}(\Sigma^{n-1}_{i=0}a''_{i}s''_i)$

$=(0,\dots,0,b'_0)-\text{LWE}_\mathbf{s}(\mathbf{a''s''})$

ここで$\text{LWE}_\mathbf{s}(\mathbf{a''s''})=(\tilde{\mathbf{a}},\tilde{\mathbf{a}}\mathbf{s} + \mathbf{a''s''} + \tilde{e})$と表すと、

$(0,\dots,0,b'_0)-\text{LWE}_\mathbf{s}(\mathbf{a''s''})$

$=(0,\dots,0,\mathbf{a''s''}+\Delta m+e_0)-(\tilde{\mathbf{a}},\tilde{\mathbf{a}}\mathbf{s} + \mathbf{a''s''} + \tilde{e})$

$=(-\tilde{\mathbf{a}},-\tilde{\mathbf{a}}\mathbf{s} + \Delta m +e_0 - \tilde{e})$

これは秘密鍵$\mathbf{s}$による$m$の暗号文になっている
