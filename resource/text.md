# 欲しいもの

* 各ステージのメタデータ

```Lua
-- 例
{
    {
        -- ステージのインデックス
        level = 0,
        -- プレイヤー
        player = {
            x = 100, -- x座標（左上の頂点）
            y = 500  -- y座標（左上の頂点）
        },
        -- 地形
        grounds = {
            -- 一つ目の地形
            {
                x = 0,   -- x座標（左上の頂点）
                y = 580, -- y座標（左上の頂点）
                w = 800, -- 横幅
                h = 80   -- 縦幅
            },
            -- 二つ目以降の地形も同様に記述
            { ... }
        },
        -- 回収できるオブジェクト
        collectables = {
            {
                x = 0,          -- x座標（左上の頂点）
                y = 580,        -- y座標（左上の頂点）
                type = "square" -- 形状
            }
        },
        -- ゴール
        goal = {
            x = 0,   -- x座標（左上の頂点）
            y = 580, -- y座標（左上の頂点）
        }
    },
    -- 他のステージも同様に記述
    { ... }
}
```