package org.gms.server;

import org.gms.server.life.Monster;
import org.gms.util.I18nUtil;
import org.gms.util.PacketCreator;

import java.util.Set;

/**
 * Adds shared combat phases to the area bosses without changing expedition bosses.
 */
public final class AreaBossEnhancementService {
    private static final Set<Integer> AREA_BOSS_MAPS = Set.of(
            800020120, 251010102, 260010201, 677000003, 677000005, 677000009,
            677000012, 677000001, 677000007, 107000300, 200010300, 100040105,
            100040106, 261030000, 110040000, 250010504, 240040401, 104000400,
            222010310, 230020100, 105090310, 101030404, 250010304, 220050000,
            220050100, 220050200, 221040301
    );
    private static final int HP_MULTIPLIER = 5;
    private static final int ATTACK_MULTIPLIER = 2;
    private static final int DEFENSE_MULTIPLIER = 2;

    private AreaBossEnhancementService() {
    }

    public static void enhanceOnSpawn(Monster monster) {
        if (!isAreaBoss(monster) || monster.isAreaBossEnhanced()) {
            return;
        }

        monster.setAreaBossEnhanced(true);
        monster.setAreaBossPhase(0);
        monster.setAreaBossBaseWatk(scale(monster.getStats().getPADamage(), ATTACK_MULTIPLIER));
        monster.setAreaBossBaseMatk(scale(monster.getStats().getMADamage(), ATTACK_MULTIPLIER));
        monster.setAreaBossBaseWdef(scale(monster.getStats().getPDDamage(), DEFENSE_MULTIPLIER));
        monster.setAreaBossBaseMdef(scale(monster.getStats().getMDDamage(), DEFENSE_MULTIPLIER));
        monster.getStats().setPADamage(monster.getAreaBossBaseWatk());
        monster.getStats().setMADamage(monster.getAreaBossBaseMatk());
        monster.getStats().setPDDamage(monster.getAreaBossBaseWdef());
        monster.getStats().setMDDamage(monster.getAreaBossBaseMdef());
        monster.setStartingHp(scale(monster.getMaxHp(), HP_MULTIPLIER));
    }

    public static void updatePhase(Monster monster) {
        if (!isAreaBoss(monster) || !monster.isAreaBossEnhanced() || monster.getMaxHp() <= 0) {
            return;
        }

        int healthPercent = monster.getHp() * 100 / monster.getMaxHp();
        int phase = healthPercent <= 25 ? 3 : healthPercent <= 50 ? 2 : healthPercent <= 75 ? 1 : 0;
        if (phase <= monster.getAreaBossPhase()) {
            return;
        }

        monster.setAreaBossPhase(phase);
        int phaseMultiplier = phase == 1 ? 5 : phase == 2 ? 6 : 8;
        monster.getStats().setPADamage(scale(monster.getAreaBossBaseWatk(), phaseMultiplier, 4));
        monster.getStats().setMADamage(scale(monster.getAreaBossBaseMatk(), phaseMultiplier, 4));
        monster.getStats().setPDDamage(scale(monster.getAreaBossBaseWdef(), phaseMultiplier, 4));
        monster.getStats().setMDDamage(scale(monster.getAreaBossBaseMdef(), phaseMultiplier, 4));
        monster.getMap().broadcastMessage(PacketCreator.serverNotice(6,
                I18nUtil.getMessage("AreaBoss.phase", monster.getName(), phase)));
    }

    private static boolean isAreaBoss(Monster monster) {
        return monster != null
                && monster.isBoss()
                && monster.getMap() != null
                && AREA_BOSS_MAPS.contains(monster.getMap().getId());
    }

    private static int scale(int value, int multiplier) {
        return scale(value, multiplier, 1);
    }

    private static int scale(int value, int multiplier, int divisor) {
        long scaled = (long) Math.max(1, value) * multiplier / divisor;
        return (int) Math.min(Integer.MAX_VALUE, Math.max(1, scaled));
    }
}
