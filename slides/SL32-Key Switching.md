---
layout: default
---

# **Key Switching**

<div></div>

## Sample Extractionで得られたLWE暗号文$(\mathbf{a''},b'_0=\mathbf{a''s''}+\Delta m + e_0)$を$\mathbf{s}$によるLWE暗号文に変換する

<br>
<div class="week5-note-card is-white">
<p class="text-center" style="font-size: 1.2rem;">
<MathInline expr="\mathbf{s}''"/>を暗号化して<MathInline expr="\text{LWE}_\mathbf{s}(\mathbf{a''s''}) = (\tilde{\mathbf{a}}, \mathbf{\tilde{a}s}+\mathbf{a''s''}+\tilde{e})"/>を公開し<br>
<MathInline expr="\mathbf{a''s''}+\Delta m +e_0 - \text{LWE}_\mathbf{s}(\mathbf{a''s''})"/>
を計算する
</p>
</div>

<div><p class="text-center">↓</p></div>

<div class="week5-note-card">
<p class="text-center" style="font-size: 1.2rem;">
<MathInline expr="\mathbf{a''s''}+\Delta m +e_0"/>から<MathInline expr="\mathbf{\tilde{a}s}+\mathbf{a''s''}+\tilde{e}"/>を引けば<MathInline expr="-\mathbf{\tilde{a}s}+\Delta m + e_0-e"/>が得られる
</p>
</div>
<br>

$-\mathbf{\tilde{a}s}+\Delta m + e_0-e"$は秘密鍵$\mathbf{s}$による$m$のLWE暗号文になっている！

しかし、毎回$\mathbf{a''}$を委託元に送って$\text{LWE}_\mathbf{s}(\mathbf{a''s''})$を送り返してもらうのは避けたい。
<!-- しかし、$\mathbf{s}''$を公開できると$\text{RGSW}_{s'}(s)$の$s'$を計算して$\mathbf{s}$を復号できてしまうので、$\mathbf{s}''$を公開して$\mathbf{a''s''}$を直接計算することはできない... -->
