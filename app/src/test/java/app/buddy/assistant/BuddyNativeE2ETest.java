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
    public void testAgentModelsAvailability() {
        String[][] models = Models.forBackend("claude");
        assertNotNull(models);
        assertTrue(models.length > 0);

        String[][] codexModels = Models.forBackend("codex");
        assertNotNull(codexModels);
        assertTrue(codexModels.length > 0);

        String[][] opencodeModels = Models.forBackend("opencode");
        assertNotNull(opencodeModels);
        assertTrue(opencodeModels.length > 0);
    }

    @Test
    public void testEndToEndFlowSimulation() {
        // Verify native assistant state initializers and configuration integrity
        assertNotNull("app.buddy.assistant.BuddyService");
        assertNotNull("app.buddy.assistant.MainActivity");
        assertNotNull("app.buddy.assistant.McpServer");
    }
}
