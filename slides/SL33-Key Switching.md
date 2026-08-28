---
layout: default
---

# **Key Switching**

## なぜ$\text{LWE}_\mathbf{s}(\Delta m)\gets (0,\dots,0,b'_0)-\Sigma^{n-1}_{i=0}\Sigma^{l-1}_{j=0}\bar{a}_{i,j}ksk[i,j]$でうまくいくのか?

<div class="key-switch-proof-columns">
  <div>
    <p style="font-size: 1.3rem;">以下のように変形する。</p>
    <div class="key-switch-proof-equation" style="font-size: 1.3rem;"><MathInline expr="\text{LWE}_\mathbf{s}(\Delta m)= (0,\dots,0,b'_0)-\Sigma^{n-1}_{i=0}\Sigma^{l-1}_{j=0}\bar{a}_{i,j}ksk[i,j]" /></div>
    <div class="key-switch-proof-equation" style="font-size: 1.3rem;"><MathInline expr="=(0,\dots,0,b'_0)-\Sigma^{n-1}_{i=0}\Sigma^{l-1}_{j=0}\bar{a}_{i,j}\text{LWE}_\mathbf{s}(s''_iq/B^{j+1})" /></div>
    <div class="key-switch-proof-equation" style="font-size: 1.3rem;"><MathInline expr="=(0,\dots,0,b'_0)-\Sigma^{n-1}_{i=0}\Sigma^{l-1}_{j=0}\text{LWE}_\mathbf{s}(\bar{a}_{i,j}s''_iq/B^{j+1})" /></div>
    <div class="key-switch-proof-equation" style="font-size: 1.3rem;"><MathInline expr="=(0,\dots,0,b'_0)-\text{LWE}_\mathbf{s}(\Sigma^{n-1}_{i=0}\Sigma^{l-1}_{j=0}\bar{a}_{i,j}s''_iq/B^{j+1})" /></div>
    <div class="key-switch-proof-equation" style="font-size: 1.3rem;"><MathInline expr="=(0,\dots,0,b'_0)-\text{LWE}_\mathbf{s}(\Sigma^{n-1}_{i=0}a''_{i}s''_i)" /></div>
    <div class="key-switch-proof-equation" style="font-size: 1.3rem;"><MathInline expr="=(0,\dots,0,b'_0)-\text{LWE}_\mathbf{s}(\langle\mathbf{a''},\mathbf{s''}\rangle)" /></div>
  </div>

  <div>
    <p style="font-size: 1.3rem;">ここで<MathInline expr="\text{LWE}_\mathbf{s}(\langle\mathbf{a''},\mathbf{s''}\rangle)=(\tilde{\mathbf{a}},\langle\tilde{\mathbf a},\mathbf s\rangle + \langle\mathbf{a''},\mathbf{s''}\rangle + \tilde{e})" />と表すと、</p>
    <div class="key-switch-proof-equation" style="font-size: 1.3rem;"><MathInline expr="(0,\dots,0,b'_0)-\text{LWE}_\mathbf{s}(\langle\mathbf{a''},\mathbf{s''}\rangle)" /></div>
    <div class="key-switch-proof-equation" style="font-size: 1.3rem;"><MathInline expr="=(0,\dots,0,\langle\mathbf{a''},\mathbf{s''}\rangle+\Delta m+e_0)-(\tilde{\mathbf{a}},\langle\tilde{\mathbf a},\mathbf s\rangle + \langle\mathbf{a''},\mathbf{s''}\rangle + \tilde{e})" /></div>
    <div class="key-switch-proof-equation" style="font-size: 1.3rem;"><MathInline expr="=(-\tilde{\mathbf{a}},-\langle\tilde{\mathbf a},\mathbf s\rangle + \Delta m +e_0 - \tilde{e})" /></div>
    <p style="font-size: 1.3rem;">これは秘密鍵<MathInline expr="\mathbf{s}" />による<MathInline expr="m" />の暗号文になっている</p>
  </div>
</div>

<style>
.key-switch-proof-columns {
  display: grid;
  grid-template-columns: minmax(0, 1fr) minmax(0, 1fr);
  column-gap: 32px;
  align-items: start;
  margin-top: 10px;
}

.key-switch-proof-columns p {
  margin: 0 0 14px;
  font-size: 18px;
  line-height: 1.45;
}

.key-switch-proof-equation {
  margin-bottom: 13px;
  font-size: 17px;
  line-height: 1.35;
  white-space: nowrap;
}
</style>
