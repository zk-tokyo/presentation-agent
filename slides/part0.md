---
layout: default
class: salary-story
---

# 導入: 3人の給与平均はいくら？

<div class="salary-layout">
  <div class="salary-copy">
    <p>3人がそれぞれ給与を持っている。知りたいのは平均だけである。</p>
    <div class="salary-formula">average = (x1 + x2 + x3) / 3</div>
    <p>普通に計算するなら、誰か1人が全員の給与を集めたり、全員が公開して計算すればよい。</p>
    <p class="salary-tension">しかし、その場合は計算者が全員の給与を見てしまう。</p>
  </div>

  <div class="salary-diagram" aria-label="個別の給与を見せずに平均だけを得る図">
    <div class="salary-parties">
      <div class="salary-party"><b>Alice</b><span>給与 x1</span><small>非公開</small></div>
      <div class="salary-party"><b>Bob</b><span>給与 x2</span><small>非公開</small></div>
      <div class="salary-party"><b>Carol</b><span>給与 x3</span><small>非公開</small></div>
    </div>
    <div class="salary-arrow">→</div>
    <div class="salary-compute"><small>共同計算</small><b>f(x1, x2, x3)</b><span>入力や途中過程は見せない</span></div>
    <div class="salary-arrow">→</div>
    <div class="salary-output"><small>OUTPUT</small><b>平均</b><span>指定された人が知る</span></div>
  </div>
</div>

<div class="salary-goal"><b>ここでやりたいこと</b><span>個別の給与は誰にも見せない。ただし、出力である平均だけは全員または指定された人が知る。</span></div>

---
layout: default
class: agenda-slide
---

# 今日の流れ

1. マルチパーティ計算(MPC: Multi-Party Computation) は何をしたい技術か
2. MPC の問題設定
3. 秘密分散
4. MPC での演算
5. セキュリティモデルと主要なMPCプロトコル
6. 応用例
7. ZK / FHE / MPC と関連技術の比較・まとめ
