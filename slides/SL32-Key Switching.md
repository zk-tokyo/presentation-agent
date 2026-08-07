---
layout: default
---

# **Key Switching**

<div></div>

## Sample Extractionで得られたLWE暗号文$(\mathbf{a''},b'_0=\mathbf{a''s''}+\Delta m + e_0)$を$\mathbf{s}$によるLWE暗号文に変換する

<div class="week5-note-card">
<p class="text-center" style="font-size: 1.2rem;">
<MathInline expr="\mathbf{a''s''}+\Delta m +e_0"/>から<MathInline expr="\mathbf{as}+\mathbf{a''s''}+e"/>を引けば<MathInline expr="-\mathbf{as}+\Delta m + e_0-e"/>が得られる
</p>
</div>

しかし、$\mathbf{s}''$を公開できると$\text{RGSW}_{s'}(s)$の$s'$を計算して$\mathbf{s}$を復号できてしまうので、$\mathbf{s}''$を公開して$\mathbf{a''s''}$を直接計算することはできない...

<div><p class="text-center">↓</p></div>
<div class="week5-note-card">
<p class="text-center" style="font-size: 1.2rem;">
<MathInline expr="\mathbf{s}''"/>を暗号化して公開し<MathInline expr="\mathbf{a''s''}+\Delta m +e_0 - \text{LWE}_\mathbf{s}(\mathbf{a''s''})"/>
を計算する
</p>
</div>
