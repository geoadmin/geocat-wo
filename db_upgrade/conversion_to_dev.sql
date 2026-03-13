
-- geocat-dev specifics
update settings set value = 'geocat-dev.dev.bgdi.ch' where name = 'system/server/host';
update settings set value = '443' where name = 'system/server/port';
update settings set value = 'https' where name = 'system/server/protocol';
update settings set value = 'xxxxxxxxxxxxxxxxxxx' where name = 'system/inspire/remotevalidation/apikey';
update settings set value = 'iso19115-3.2018.che' where name = 'metadata/import/restrict';

update metadata set data=replace(data, 'https://www.geocat.ch', 'https://geocat-dev.dev.bgdi.ch') where data like '%https://www.geocat.ch%';
update metadata set data=replace(data, 'http://www.geocat.ch/geonetwork', 'http://geocat-dev.dev.bgdi.ch/geonetwork') where data like '%http://www.geocat.ch/geonetwork%';
update metadata set data=replace(data, 'https://geocat-int.dev.bgdi.ch', 'https://geocat-dev.dev.bgdi.ch') where data like '%https://geocat-int.dev.bgdi.ch%';
update metadata set data=replace(data, 'http://geocat-int.dev.bgdi.ch/geonetwork', 'http://geocat-dev.dev.bgdi.ch/geonetwork') where data like '%http://geocat-int.dev.bgdi.ch/geonetwork%';

update harvestersettings set value='inactive' where name='status';
