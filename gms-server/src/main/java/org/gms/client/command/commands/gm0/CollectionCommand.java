package org.gms.client.command.commands.gm0;

import org.gms.client.Client;
import org.gms.client.command.Command;
import org.gms.server.CollectionService;
import org.gms.util.I18nUtil;

public class CollectionCommand extends Command {
    {
        setDescription(I18nUtil.getMessage("CollectionCommand.message1"));
    }

    @Override
    public void execute(Client client, String[] params) {
        if (params.length > 0) {
            client.getPlayer().dropMessage(5, I18nUtil.getMessage("CollectionCommand.message2"));
            return;
        }

        client.getPlayer().showHint(
                CollectionService.getInstance().formatStatus(client.getPlayer()),
                600
        );
    }
}
