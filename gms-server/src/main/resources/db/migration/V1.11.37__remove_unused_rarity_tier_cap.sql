-- Affix tier is now determined by equipment requirement level and weighted
-- variance; equipment quality only controls primary/secondary affix counts.
ALTER TABLE `equipment_rarity_config`
    DROP COLUMN `max_affix_tier`;
