package org.fao.geonet.kernel.harvest.harvester.localfilesystem;


import org.fao.geonet.ApplicationContextHolder;
import org.fao.geonet.kernel.GeonetworkDataDirectory;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.context.ConfigurableApplicationContext;

@ExtendWith(MockitoExtension.class)
public class LocalFilesystemHarvesterTest {

	@Test
	public void noRunBeforeScript() throws Exception {
		LocalFilesystemHarvester toTest = new LocalFilesystemHarvester();
		LocalFilesystemParams params = toTest.createParams();
		toTest.setParams(params);

		toTest.runBeforeScript();
	}

	@Test
	public void runBeforeScript() throws Exception {
		ConfigurableApplicationContext mockContext = Mockito.mock(ConfigurableApplicationContext.class);
		ApplicationContextHolder.set(mockContext);
		GeonetworkDataDirectory mockDataDirectory = Mockito.mock(GeonetworkDataDirectory.class);
		Mockito.when(mockContext.getBean(Mockito.eq(GeonetworkDataDirectory.class))).thenReturn(mockDataDirectory);

		LocalFilesystemHarvester toTest = new LocalFilesystemHarvester();
		LocalFilesystemParams params = toTest.createParams();
		params.beforeScript = "notAllowed";
		toTest.setParams(params);

		toTest.runBeforeScript();
	}

}