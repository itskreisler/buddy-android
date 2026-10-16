package app.buddy.assistant;

import org.junit.Test;
import static org.junit.Assert.*;

public class BuddyNativeE2ETest {

    @Test
    public void testBuildInfoAndVersionConfig() {
        assertNotNull(BuildInfo.VERSION);
        assertTrue(BuildInfo.VERSION_CODE > 0);
        assertTrue(BuildInfo.VERSION.length() > 0);
    }

    @Test
    public void testAgentModelsAndEffortLevels() {
        // Claude models and effort levels
        String[][] claudeModels = Models.forBackend("claude");
        assertNotNull(claudeModels);
        assertTrue(claudeModels.length >= 3);
        String[][] claudeEfforts = Models.efforts("claude");
        assertNotNull(claudeEfforts);
        assertTrue(claudeEfforts.length > 0);

        // Codex models and effort levels
        String[][] codexModels = Models.forBackend("codex");
        assertNotNull(codexModels);
        assertTrue(codexModels.length >= 2);
        String[][] codexEfforts = Models.efforts("codex");
        assertNotNull(codexEfforts);

        // OpenCode models
        String[][] opencodeModels = Models.forBackend("opencode");
        assertNotNull(opencodeModels);
        assertTrue(opencodeModels.length >= 1);
    }

    @Test
    public void testGuardNormalization() {
        assertEquals("añadir al carrito", Guard.norm("  Añadir  al  carrito  "));
        assertEquals("whatsapp", Guard.norm("WhatsApp"));
    }
}
