GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })

PrefabFiles =
{
    "sw_bleedingbuff",
    "sw_bloodstainfx"
}

AddPlayerPostInit(function(inst)
    if inst.components and inst.components.health then
        print(inst)
        inst:ListenForEvent("healthdelta", function(inst, data)
            if data then
                -- 经过测试, data.oldpercent, data.newpercent 分别指的是扣血前后的血量百分比，而 data.amount 是血量变化的值(负数则为扣血)
                -- print(data.oldpercent..""..data.newpercent..""..data.amount)
                if data.amount < 0 then
                    -- print("扣血" .. data.amount)
                    -- 人物当前位置
                    local fx = SpawnPrefab("sw_bloodstainfx")
                    -- fx.entity:SetParent(inst.entity)
                    local x, y, z = inst:GetPosition():Get()
                    fx.Transform:SetPosition(x, y, z)
                end
                if data.oldpercent - data.newpercent > 0.1 then
                    -- 开始流血效果
                    if inst.components.debuffable then
                        inst.components.debuffable:AddDebuff("sw_bleedingbuff", "sw_bleedingbuff")
                        print("AddDebuff sw_bleedingbuff")
                    end
                end
            end
        end)
    end
end)

AddPrefabPostInitAny(function(inst)
    if inst:HasTag("largecreature") then
        local function OnHitOther(inst, other)
            num = math.random()
            if num > 0.5 then
                other:PushEvent("knockback", {
                    knocker = inst,
                    radius = 200 * num,
                    strengthmult = num
                })
            end
        end

        if inst.components.combat ~= nil then
            inst.components.combat.onhitotherfn = OnHitOther
        end
    end
end)
-- TODO 让血迹能很久再消失
