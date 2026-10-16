package app.buddy.assistant;

import androidx.test.ext.junit.runners.AndroidJUnit4;
import org.junit.Test;
import org.junit.runner.RunWith;

import static org.junit.Assert.assertNotNull;

@RunWith(AndroidJUnit4.class)
public class BuddyE2ETest {

    @Test
    public void testInstrumentationE2ESetup() {
        assertNotNull(BuildInfo.VERSION);
    }
}
