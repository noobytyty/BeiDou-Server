package org.gms.client.command.commands.gm0;

import org.gms.client.Client;
import org.gms.client.command.Command;
import org.gms.client.inventory.Equip;
import org.gms.client.inventory.EquipmentAffixPowder;
import org.gms.client.inventory.EquipmentValueCalculator;
import org.gms.client.inventory.InventoryType;
import org.gms.client.inventory.manipulator.InventoryManipulator;
import org.gms.server.ItemInformationProvider;
import org.gms.util.I18nUtil;

import java.util.Map;
import java.util.stream.Collectors;

public class SalvageEquipmentCommand extends Command {
    private static final ItemInformationProvider ITEM_INFORMATION_PROVIDER = ItemInformationProvider.getInstance();
    {
        setDescription(I18nUtil.getMessage("SalvageEquipmentCommand.message1"));
    }

    @Override
    public void execute(Client client, String[] params) {
        if (params.length != 1) {
            client.getPlayer().dropMessage(5, I18nUtil.getMessage("SalvageEquipmentCommand.message2"));
            return;
        }
        try {
            short slot = Short.parseShort(params[0]);
            if (!(client.getPlayer().getInventory(InventoryType.EQUIP).getItem(slot) instanceof Equip equip)) {
                client.getPlayer().dropMessage(5, I18nUtil.getMessage("SalvageEquipmentCommand.message3"));
                return;
            }
            int reward = EquipmentValueCalculator.getSalvagePrice(equip);
            Map<Integer, Integer> powderGains = EquipmentAffixPowder.gainsFor(equip);
            for (Map.Entry<Integer, Integer> entry : powderGains.entrySet()) {
                if (!client.getPlayer().canHold(entry.getKey(), entry.getValue())) {
                    client.getPlayer().dropMessage(5, I18nUtil.getMessage(
                            "SalvageEquipmentCommand.message5"));
                    return;
                }
            }
            InventoryManipulator.removeFromSlot(client, InventoryType.EQUIP, slot, (short) 1, false);
            powderGains.forEach((itemId, quantity) ->
                    InventoryManipulator.addById(client, itemId, quantity.shortValue()));
            client.getPlayer().gainMeso(reward, true, false, true);
            client.getPlayer().dropMessage(5, I18nUtil.getMessage("SalvageEquipmentCommand.message4", reward));
        } catch (NumberFormatException exception) {
            client.getPlayer().dropMessage(5, I18nUtil.getMessage("SalvageEquipmentCommand.message2"));
        }
    }

    public static String preview(Equip equip) {
        String powders = EquipmentAffixPowder.gainsFor(equip).entrySet().stream()
                .map(entry -> ITEM_INFORMATION_PROVIDER.getName(entry.getKey()) + " x" + entry.getValue())
                .collect(Collectors.joining("、"));
        return I18nUtil.getMessage("SalvageEquipmentCommand.preview",
                EquipmentValueCalculator.getSalvagePrice(equip), powders);
    }
}
