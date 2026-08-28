---
layout: default
---

# **Key Switching**

<div></div>

## Sample Extractionで得られたLWE暗号文$(\mathbf{a''},b'_0=\langle\mathbf{a''},\mathbf{s''}\rangle+\Delta m + e_0)$を$\mathbf{s}$によるLWE暗号文に変換する

<br>
<div class="week5-note-card is-white">
<p class="text-center" style="font-size: 1.2rem;">
<MathInline expr="\mathbf{s}''"/>を暗号化して<MathInline expr="\text{LWE}_\mathbf{s}(\langle\mathbf{a''},\mathbf{s''}\rangle) = (\tilde{\mathbf{a}}, \langle\tilde{\mathbf a},\mathbf s\rangle+\langle\mathbf{a''},\mathbf{s''}\rangle+\tilde{e})"/>を公開し<br>
<MathInline expr="\langle\mathbf{a''},\mathbf{s''}\rangle+\Delta m +e_0 - \text{LWE}_\mathbf{s}(\langle\mathbf{a''},\mathbf{s''}\rangle)"/>
を計算する
</p>
</div>

<div><p class="text-center">↓</p></div>

<div class="week5-note-card">
<p class="text-center" style="font-size: 1.2rem;">
<MathInline expr="\langle\mathbf{a''},\mathbf{s''}\rangle+\Delta m +e_0"/>から<MathInline expr="\langle\tilde{\mathbf a},\mathbf s\rangle+\langle\mathbf{a''},\mathbf{s''}\rangle+\tilde{e}"/>を引けば<MathInline expr="-\langle\tilde{\mathbf a},\mathbf s\rangle+\Delta m + e_0-e"/>が得られる
</p>
</div>
<br>

$-\langle\tilde{\mathbf a},\mathbf s\rangle+\Delta m + e_0-e"$は秘密鍵$\mathbf{s}$による$m$のLWE暗号文になっている！

しかし、毎回$\mathbf{a''}$を委託元に送って$\text{LWE}_\mathbf{s}(\langle\mathbf{a''},\mathbf{s''}\rangle)$を送り返してもらうのは避けたい。
<!-- しかし、$\mathbf{s}''$を公開できると$\text{RGSW}_{s'}(s)$の$s'$を計算して$\mathbf{s}$を復号できてしまうので、$\mathbf{s}''$を公開して$\langle\mathbf{a''},\mathbf{s''}\rangle$を直接計算することはできない... -->
