PrefabFiles = {"bleedingbuff"}

AddPlayerPostInit(function (inst)
    if inst.components and inst.components.health then
        print(inst)
        
        inst:ListenForEvent("healthdelta", function (inst, data)
            if data then
                -- 经过测试, data.oldpercent, data.newpercent 分别指的是扣血前后的血量百分比，而 data.amount 是血量变化的值(负数则为扣血)
                -- print(data.oldpercent..""..data.newpercent..""..data.amount)
                if data.oldpercent - data.newpercent > 0.1 then
                    -- 开始流血效果
                    if inst.components.debuffable then
                        inst.components.debuffable:AddDebuff("bleedingbuff", "bleedingbuff")
                        print("AddDebuff bleedingbuff")
                    end
                end
            end
        end)
    end
end)