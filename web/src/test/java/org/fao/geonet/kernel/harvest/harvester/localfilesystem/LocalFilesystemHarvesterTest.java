package org.fao.geonet.kernel.harvest.harvester.localfilesystem;


import org.fao.geonet.ApplicationContextHolder;
import org.fao.geonet.kernel.GeonetworkDataDirectory;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.MockedConstruction;
import org.mockito.MockedStatic;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.context.ConfigurableApplicationContext;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;
import static org.mockito.Mockito.mockConstruction;
import static org.mockito.Mockito.mockStatic;

@ExtendWith(MockitoExtension.class)
public class LocalFilesystemHarvesterTest {

    @Test
    public void runBeforeScriptWithEmptyScript() {
        LocalFilesystemHarvester toTest = new LocalFilesystemHarvester();
        LocalFilesystemParams params = toTest.createParams();
        params.beforeScript = "";
        toTest.setParams(params);

        try {
            toTest.runBeforeScript();
        } catch (Exception e) {
            fail("Did not exit properly with an empty script");
        }
    }

    @Test
    public void runBeforeScriptWithDisallowedPath() {
        ConfigurableApplicationContext mockContext = mock(ConfigurableApplicationContext.class);
        ApplicationContextHolder.set(mockContext);

        LocalFilesystemHarvester toTest = new LocalFilesystemHarvester();
        LocalFilesystemParams params = toTest.createParams();
        params.beforeScript = "../disallowed/script.sh";
        toTest.setParams(params);

        RuntimeException exception = assertThrows(RuntimeException.class, toTest::runBeforeScript);

        assertEquals("The beforeScript can't contains '..'.", exception.getMessage());
    }

    @Test
    public void testRunBeforeScriptWithNonexistentScript() {
        try (MockedStatic<Files> filesMock = mockStatic(Files.class)) {
            ConfigurableApplicationContext mockContext = mock(ConfigurableApplicationContext.class);
            ApplicationContextHolder.set(mockContext);
            GeonetworkDataDirectory mockDataDirectory = mock(GeonetworkDataDirectory.class);
            Path mockDir = mock(Path.class);
            Path mockScriptPath = mock(Path.class);

            when(mockDataDirectory.getConfigDir()).thenReturn(mockDir);
            when(mockDir.resolve("nonexistentScript.sh")).thenReturn(mockScriptPath);
            when(mockContext.getBean(eq(GeonetworkDataDirectory.class))).thenReturn(mockDataDirectory);

            // Mock Files.exists() to return false for the script path
            filesMock.when(() -> Files.exists(mockScriptPath)).thenReturn(false);

            LocalFilesystemHarvester toTest = new LocalFilesystemHarvester();
            LocalFilesystemParams params = toTest.createParams();
            params.beforeScript = "nonexistentScript.sh"; // Script does not exist
            toTest.setParams(params);

            RuntimeException exception = assertThrows(RuntimeException.class, toTest::runBeforeScript);
            assertEquals("Script nonexistentScript.sh is not allowed. Only script in the data directory can be triggered.", exception.getMessage());
        }
    }

    @Test
    public void runBeforeScriptWithSemicolon() {
        try (MockedStatic<Files> filesMock = mockStatic(Files.class)) {
            ConfigurableApplicationContext mockContext = mock(ConfigurableApplicationContext.class);
            ApplicationContextHolder.set(mockContext);
            GeonetworkDataDirectory mockDataDirectory = mock(GeonetworkDataDirectory.class);
            Path mockDir = mock(Path.class);
            Path scriptPath = mock(Path.class);

            when(mockDataDirectory.getConfigDir()).thenReturn(mockDir);
            when(mockDir.resolve("safeScript.sh;")).thenReturn(scriptPath);
            when(scriptPath.toString()).thenReturn("/path/toMockDir/safeScript.sh;");
            when(mockContext.getBean(eq(GeonetworkDataDirectory.class))).thenReturn(mockDataDirectory);

            filesMock.when(() -> Files.exists(scriptPath)).thenReturn(true);

            LocalFilesystemHarvester toTest = new LocalFilesystemHarvester();
            LocalFilesystemParams params = toTest.createParams();
            params.beforeScript = "safeScript.sh; rm -rf /";
            toTest.setParams(params);

            // WHEN
            RuntimeException exception = assertThrows(RuntimeException.class, toTest::runBeforeScript);

            assertEquals("The beforeScript can't contains ';'. Only one script can be triggered.", exception.getMessage());
        }
    }

    @Test
    public void runBeforeScriptAllowedScriptExecution() throws IOException, InterruptedException {
        try (MockedStatic<Files> filesMock = mockStatic(Files.class);
             MockedConstruction<ProcessBuilder> ignored = mockConstruction(ProcessBuilder.class,
                     (mock, context) -> {
                         Process mockProcess = mock(Process.class);
                         when(mockProcess.waitFor()).thenReturn(0);
                         when(mock.redirectError(any(ProcessBuilder.Redirect.class))).thenReturn(mock);
                         when(mock.redirectOutput(any(ProcessBuilder.Redirect.class))).thenReturn(mock);
                         when(mock.start()).thenReturn(mockProcess);
                     })) {

            ConfigurableApplicationContext mockContext = mock(ConfigurableApplicationContext.class);
            ApplicationContextHolder.set(mockContext);
            GeonetworkDataDirectory mockDataDirectory = mock(GeonetworkDataDirectory.class);
            Path mockDir = mock(Path.class);
            Path validScriptPath = mock(Path.class);

            when(mockDataDirectory.getConfigDir()).thenReturn(mockDir);
            when(mockDir.resolve("safeScript.sh")).thenReturn(validScriptPath);
            when(validScriptPath.toString()).thenReturn("/mock/path/safeScript.sh");
            when(mockContext.getBean(eq(GeonetworkDataDirectory.class))).thenReturn(mockDataDirectory);

            filesMock.when(() -> Files.exists(validScriptPath)).thenReturn(true);

            LocalFilesystemHarvester toTest = new LocalFilesystemHarvester();
            LocalFilesystemParams params = toTest.createParams();
            params.beforeScript = "safeScript.sh";
            toTest.setParams(params);

            try {
                toTest.runBeforeScript();
            } catch (Exception e) {
                fail("Did not successfully run the script");
            }
        }
    }
}