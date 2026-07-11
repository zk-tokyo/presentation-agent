---
layout: default
---

# Programmable Bootstrappingの基本アイディア

## Bootstrappingでやりたいこと=暗号文のノイズを減らす

<div class="week5-note-card">
<p style="font-size: 1.2rem;">平文のリストに対するノイズの少ない暗号文から、目的の平文の部分だけ切り出す</p>
</div>

<div style="position: absolute; left: 150px; top: 292px; width: 920px; height: 300px;">
  <div style="position: absolute; left: 20px; top: 0; width: 700px; height: 92px; border: 2px solid #f3e7a6; border-radius: 14px; background: #fffdf4;">
    <div style="position: absolute; left: 18px; top: -22px; padding: 3px 12px; border: 2px solid #f3e7a6; background: #ffffff; font-size: 1rem; line-height: 1.3;">ノイズの少ない暗号文</div>
    <div style="position: absolute; left: 22px; top: 24px; width: 650px; height: 48px; display: grid; grid-template-columns: repeat(10, 1fr); border: 1.5px solid #17324d; border-right: 0; background: #ffffff;">
      <div style="display: grid; place-items: center; border-right: 1.5px solid #17324d; font-size: 1rem;"><MathInline expr="m_0"/></div>
      <div style="display: grid; place-items: center; border-right: 1.5px solid #17324d; font-size: 1rem;"><MathInline expr="m_0"/></div>
      <div style="display: grid; place-items: center; border-right: 1.5px solid #17324d; font-size: 1rem;">...</div>
      <div style="display: grid; place-items: center; border-right: 1.5px solid #17324d; font-size: 1rem;"><MathInline expr="m_1"/></div>
      <div style="display: grid; place-items: center; border-right: 1.5px solid #17324d; font-size: 1rem;"><MathInline expr="m_1"/></div>
      <div style="display: grid; place-items: center; border-right: 1.5px solid #17324d; font-size: 1rem;">...</div>
      <div style="display: grid; place-items: center; border-right: 1.5px solid #17324d; font-size: 1rem;">...</div>
      <div style="display: grid; place-items: center; border-right: 1.5px solid #17324d; font-size: 1rem;">...</div>
      <div style="display: grid; place-items: center; border-right: 1.5px solid #17324d; font-size: 1rem;"><MathInline expr="m_{p-1}"/></div>
      <div style="display: grid; place-items: center; border-right: 1.5px solid #17324d; font-size: 1rem;"><MathInline expr="m_{p-1}"/></div>
    </div>
  </div>

  <div style="position: absolute; left: 352px; top: 112px; width: 72px; height: 86px;">
    <div style="position: absolute; left: 24px; top: 0; width: 24px; height: 54px; border: 2px solid #7fb3c8; background: #f8fbfd;"></div>
    <div style="position: absolute; left: 8px; top: 50px; width: 0; height: 0; border-left: 28px solid transparent; border-right: 28px solid transparent; border-top: 34px solid #7fb3c8;"></div>
    <div style="position: absolute; left: 13px; top: 50px; width: 0; height: 0; border-left: 23px solid transparent; border-right: 23px solid transparent; border-top: 28px solid #ffffff;"></div>
  </div>

  <div style="position: absolute; left: 462px; top: 118px; width: 385px; font-size: 1rem; line-height: 1.55; color: #111827;">
    暗号文<MathInline expr="(\mathbf{a},b=\mathbf{as}+\Delta m+e)"/><br>
    と同じ平文を持つ部分だけ切り出す
  </div>

  <div style="position: absolute; left: 300px; top: 198px; width: 180px; height: 98px; border: 2px solid #f3e7a6; border-radius: 14px; background: #fffdf4;">
    <div style="position: absolute; left: -188px; top: -16px; padding: 3px 12px; border: 2px solid #f3e7a6; background: #ffffff; font-size: 1rem; line-height: 1.3; white-space: nowrap;">ノイズの少ない暗号文</div>
    <div style="position: absolute; left: 50px; top: 22px; width: 76px; height: 56px; display: grid; place-items: center; border: 1.5px solid #17324d; background: #ffffff; font-size: 1rem;">
      <MathInline expr="m"/>
    </div>
  </div>
</div>
