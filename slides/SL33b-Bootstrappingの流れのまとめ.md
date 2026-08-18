---
layout: default
---

# Bootstrappingの流れのまとめ

<div class="bootstrap-summary-lead">
  暗号文の形式と秘密鍵を変えながら、同じ平文 <MathInline expr="m"/> の暗号文を作り直す
</div>

<div class="bootstrap-summary-steps">
  <section class="bootstrap-summary-step">
    <div class="bootstrap-summary-heading">
      <span>1</span><strong>Blind Rotation</strong>
    </div>
    <div class="bootstrap-summary-types">
      <span><MathInline expr="\mathrm{LWE}_{\mathbf{s}}(\Delta m)"/></span>
      <b>→</b>
      <span><MathInline expr="\mathrm{RLWE}_{s'}(\Delta\mu(x))"/></span>
    </div>
    <div class="bootstrap-summary-note">LWE暗号文を回転量として使う</div>
    <div class="bootstrap-rotation-visual">
      <div class="bootstrap-slot-row">
        <span><MathInline expr="\mu_0"/></span><span><MathInline expr="\mu_1"/></span><span><MathInline expr="\mu_2"/></span><span class="is-target"><MathInline expr="m"/></span>
      </div>
      <div class="bootstrap-operation-label">CMUXを反復　↓</div>
      <div class="bootstrap-slot-row">
        <span class="is-target"><MathInline expr="m"/></span><span><MathInline expr="\mu_0"/></span><span><MathInline expr="\mu_1"/></span><span><MathInline expr="\mu_2"/></span>
      </div>
    </div>
    <div class="bootstrap-summary-explain">目的の係数を定数項へ移動する</div>
  </section>

  <div class="bootstrap-summary-arrow">→</div>

  <section class="bootstrap-summary-step">
    <div class="bootstrap-summary-heading">
      <span>2</span><strong>Sample Extraction</strong>
    </div>
    <div class="bootstrap-summary-types">
      <span><MathInline expr="\mathrm{RLWE}_{s'}(\Delta\mu(x))"/></span>
      <b>→</b>
      <span><MathInline expr="\mathrm{LWE}_{\mathbf{s''}}(\Delta m)"/></span>
    </div>
    <div class="bootstrap-summary-note">RLWEからLWEへ形式を変える</div>
    <div class="bootstrap-extraction-visual">
      <div class="bootstrap-coeff-row">
        <span class="is-target"><MathInline expr="b'_0"/></span><span><MathInline expr="b'_1"/></span><span><MathInline expr="b'_2"/></span><span>…</span>
      </div>
      <div class="bootstrap-operation-label">定数項を切り出す　↓</div>
      <div class="bootstrap-cipher-pill"><MathInline expr="(\mathbf{a''},b'_0)"/></div>
    </div>
    <div class="bootstrap-summary-explain">定数項をLWE暗号文として取り出す</div>
  </section>

  <div class="bootstrap-summary-arrow">→</div>

  <section class="bootstrap-summary-step">
    <div class="bootstrap-summary-heading">
      <span>3</span><strong>Key Switching</strong>
    </div>
    <div class="bootstrap-summary-types">
      <span><MathInline expr="\mathrm{LWE}_{\mathbf{s''}}(\Delta m)"/></span>
      <b>→</b>
      <span><MathInline expr="\mathrm{LWE}_{\mathbf{s}}(\Delta m)"/></span>
    </div>
    <div class="bootstrap-summary-note">LWEのまま秘密鍵を変える</div>
    <div class="bootstrap-key-visual">
      <div><small>抽出後の鍵</small><MathInline expr="\mathbf{s''}"/></div>
      <span>→</span>
      <div class="is-target"><small>元の鍵</small><MathInline expr="\mathbf{s}"/></div>
    </div>
    <div class="bootstrap-summary-explain">平文を保ったまま元の秘密鍵へ戻す</div>
  </section>
</div>

<div class="bootstrap-summary-result">
  <div class="bootstrap-summary-result-main">
    <div class="bootstrap-summary-result-state">
      <small>入力</small>
      <strong><MathInline expr="\mathrm{LWE}_{\mathbf{s}}(\Delta m)"/></strong>
      <span>古いノイズ <MathInline expr="e"/></span>
    </div>
    <b>→</b>
    <div class="bootstrap-summary-result-process">
      <strong>Bootstrapping</strong>
      <span>平文 <MathInline expr="m"/> を保持</span>
    </div>
    <b>→</b>
    <div class="bootstrap-summary-result-state is-output">
      <small>出力</small>
      <strong><MathInline expr="\mathrm{LWE}_{\mathbf{s}}(\Delta m)"/></strong>
      <span>新しいノイズ <MathInline expr="e_{\mathrm{new}}"/></span>
    </div>
  </div>
  <div class="bootstrap-summary-result-caption">全体の入出力は、同じ平文 <MathInline expr="m"/> に対するLWE暗号文</div>
</div>

<style>
.bootstrap-summary-lead {
  margin-top: 12px;
  color: #111827;
  font-size: 1.08rem;
  line-height: 1.45;
}

.bootstrap-summary-steps {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 34px minmax(0, 1fr) 34px minmax(0, 1fr);
  align-items: stretch;
  margin-top: 18px;
}

.bootstrap-summary-step {
  display: grid;
  grid-template-rows: 34px 48px 25px 148px auto;
  min-width: 0;
  height: 350px;
  padding: 16px 15px 14px;
  border: 1px solid #c9d8ea;
  border-radius: 8px;
  background: #ffffff;
}

.bootstrap-summary-heading {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 9px;
  color: #101820;
  font-size: 1rem;
  line-height: 1;
}

.bootstrap-summary-heading > span {
  display: grid;
  place-items: center;
  width: 25px;
  height: 25px;
  border: 1px solid #17324d;
  border-radius: 999px;
  background: #f2f7fc;
  color: #17324d;
  font-size: 0.78rem;
  font-weight: 700;
}

.bootstrap-summary-types {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 18px minmax(0, 1fr);
  align-items: center;
  gap: 5px;
  margin-top: 4px;
}

.bootstrap-summary-types > span {
  display: grid;
  place-items: center;
  min-height: 36px;
  padding: 3px 5px;
  border: 1px solid #c9d8ea;
  border-radius: 5px;
  background: #fafafa;
  font-size: 0.73rem;
  line-height: 1.1;
  white-space: nowrap;
}

.bootstrap-summary-types > b {
  color: #17324d;
  font-size: 0.9rem;
  text-align: center;
}

.bootstrap-summary-note {
  align-self: center;
  color: #444444;
  font-size: 0.74rem;
  line-height: 1.2;
  text-align: center;
}

.bootstrap-summary-arrow {
  display: grid;
  place-items: center;
  color: #17324d;
  font-size: 1.35rem;
  font-weight: 700;
}

.bootstrap-rotation-visual,
.bootstrap-extraction-visual {
  display: grid;
  align-content: center;
  justify-items: center;
  gap: 12px;
}

.bootstrap-slot-row,
.bootstrap-coeff-row {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 5px;
  width: 248px;
}

.bootstrap-slot-row > span,
.bootstrap-coeff-row > span {
  display: grid;
  place-items: center;
  height: 30px;
  border: 1px solid #c9d8ea;
  border-radius: 5px;
  background: #fafafa;
  font-size: 0.76rem;
}

.bootstrap-slot-row > span.is-target,
.bootstrap-coeff-row > span.is-target {
  border-color: #17324d;
  background: #f2f7fc;
  color: #17324d;
  font-weight: 700;
}

.bootstrap-operation-label {
  color: #17324d;
  font-size: 0.76rem;
  font-weight: 700;
  line-height: 1;
}

.bootstrap-cipher-pill {
  display: grid;
  place-items: center;
  min-width: 142px;
  height: 36px;
  border: 1px solid #17324d;
  border-radius: 5px;
  background: #f2f7fc;
  font-size: 0.84rem;
}

.bootstrap-key-visual {
  display: grid;
  grid-template-columns: 112px 32px 112px;
  align-items: center;
  justify-content: center;
  gap: 6px;
}

.bootstrap-key-visual > div {
  display: grid;
  place-items: center;
  gap: 5px;
  height: 72px;
  border: 1px solid #c9d8ea;
  border-radius: 7px;
  background: #fafafa;
  font-size: 1rem;
}

.bootstrap-key-visual > div.is-target {
  border-color: #17324d;
  background: #f2f7fc;
}

.bootstrap-key-visual small {
  color: #444444;
  font-size: 0.66rem;
  line-height: 1;
}

.bootstrap-key-visual > span {
  color: #17324d;
  font-size: 1.15rem;
  font-weight: 700;
  text-align: center;
}

.bootstrap-summary-explain {
  align-self: end;
  min-height: 46px;
  padding-top: 10px;
  border-top: 1px solid #e0e0e0;
  color: #111827;
  font-size: 0.86rem;
  line-height: 1.35;
  text-align: center;
}

.bootstrap-summary-result {
  display: grid;
  grid-template-rows: auto auto;
  min-height: 80px;
  margin-top: 16px;
  padding: 8px 18px 7px;
  border-left: 3px solid #17324d;
  border-radius: 7px;
  background: #f2f7fc;
  color: #101820;
  line-height: 1.25;
}

.bootstrap-summary-result-main {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 16px;
}

.bootstrap-summary-result-main > b {
  color: #17324d;
  font-size: 1rem;
}

.bootstrap-summary-result-state {
  display: grid;
  grid-template-columns: 38px 1fr auto;
  align-items: center;
  gap: 9px;
  min-width: 282px;
  min-height: 38px;
  padding: 4px 10px;
  border: 1px solid #c9d8ea;
  border-radius: 5px;
  background: #ffffff;
}

.bootstrap-summary-result-state.is-output {
  border-color: #17324d;
}

.bootstrap-summary-result-state small {
  color: #444444;
  font-size: 0.68rem;
  font-weight: 700;
}

.bootstrap-summary-result-state strong {
  font-size: 0.82rem;
  text-align: center;
}

.bootstrap-summary-result-state > span {
  color: #444444;
  font-size: 0.69rem;
}

.bootstrap-summary-result-process {
  display: grid;
  place-items: center;
  min-width: 170px;
  line-height: 1.15;
}

.bootstrap-summary-result-process strong {
  font-size: 0.82rem;
}

.bootstrap-summary-result-process span {
  margin-top: 3px;
  color: #444444;
  font-size: 0.69rem;
}

.bootstrap-summary-result-caption {
  margin-top: 5px;
  color: #101820;
  font-size: 0.75rem;
  font-weight: 700;
  text-align: center;
}
</style>
