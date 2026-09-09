package org.gms.client.command.commands.gm0;

import org.gms.client.Client;
import org.gms.client.command.Command;
import org.gms.client.inventory.Equip;
import org.gms.client.inventory.EquipmentAffix;
import org.gms.client.inventory.EquipmentAffixGenerator;
import org.gms.client.inventory.EquipmentAffixPowder;
import org.gms.client.inventory.InventoryType;
import org.gms.client.inventory.manipulator.InventoryManipulator;
import org.gms.server.ItemInformationProvider;
import org.gms.util.I18nUtil;

import java.util.Map;
import java.util.stream.Collectors;

public class RerollAffixCommand extends Command {
    private static final ItemInformationProvider ITEM_INFORMATION_PROVIDER = ItemInformationProvider.getInstance();
    private static final long BASE_REROLL_COST = 50_000L;

    {
        setDescription(I18nUtil.getMessage("RerollAffixCommand.message1"));
    }

    @Override
    public void execute(Client client, String[] params) {
        if (params.length != 1) {
            client.getPlayer().dropMessage(5, I18nUtil.getMessage("RerollAffixCommand.message2"));
            return;
        }
        try {
            short slot = Short.parseShort(params[0]);
            if (!(client.getPlayer().getInventory(InventoryType.EQUIP).getItem(slot) instanceof Equip equip)) {
                client.getPlayer().dropMessage(5, I18nUtil.getMessage("RerollAffixCommand.message3"));
                return;
            }
            int cost = calculateRerollCost(equip);
            Map<Integer, Integer> powderCost = EquipmentAffixPowder.rerollCostFor(equip);
            if (client.getPlayer().getMeso() < cost) {
                client.getPlayer().dropMessage(5, I18nUtil.getMessage("RerollAffixCommand.message4", cost));
                return;
            }
            for (Map.Entry<Integer, Integer> entry : powderCost.entrySet()) {
                if (client.getPlayer().countItem(entry.getKey()) < entry.getValue()) {
                    client.getPlayer().dropMessage(5, I18nUtil.getMessage(
                            "RerollAffixCommand.message6",
                            ITEM_INFORMATION_PROVIDER.getName(entry.getKey()), entry.getValue()));
                    return;
                }
            }
            client.getPlayer().gainMeso(-cost, true, false, true);
            powderCost.forEach((itemId, quantity) -> InventoryManipulator.removeById(
                    client, InventoryType.ETC, itemId, quantity, false, false));
            EquipmentAffixGenerator.reroll(equip, true);
            client.getPlayer().forceUpdateItem(equip);
            client.getPlayer().dropMessage(5, I18nUtil.getMessage(
                    "RerollAffixCommand.message5", cost, powderCost.values().stream().mapToInt(Integer::intValue).sum()));
        } catch (NumberFormatException exception) {
            client.getPlayer().dropMessage(5, I18nUtil.getMessage("RerollAffixCommand.message2"));
        }
    }

    private int calculateRerollCost(Equip equip) {
        double rarityMultiplier = Math.pow(1.8, Math.max(0, equip.getRarity()));
        long lockedCount = equip.getAffixes().stream().filter(EquipmentAffix::isLocked).count();
        double lockMultiplier = Math.pow(1.6, lockedCount);
        double multiplier = rarityMultiplier * lockMultiplier;
        return (int) (Math.round(BASE_REROLL_COST * multiplier / 1_000) * 1_000);
    }

    public static String preview(Equip equip) {
        Map<Integer, Integer> powderCost = EquipmentAffixPowder.rerollCostFor(equip);
        String powders = powderCost.entrySet().stream()
                .map(entry -> ITEM_INFORMATION_PROVIDER.getName(entry.getKey()) + " x" + entry.getValue())
                .collect(Collectors.joining("、"));
        return I18nUtil.getMessage("RerollAffixCommand.preview",
                new RerollAffixCommand().calculateRerollCost(equip), powders);
    }
}
