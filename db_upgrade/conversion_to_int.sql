update settings set value = 'geocat-int.apps.geocat-mgdi.swisstopo.cloud' where name = 'system/server/host';
update settings set value = '443' where name = 'system/server/port';
update settings set value = 'https' where name = 'system/server/protocol';
update settings set value = 'iso19115-3.2018.che' where name = 'metadata/import/restrict';

update metadata set data=replace(data, 'http://geocat.lt.admin.ch', 'https://geocat-int.apps.geocat-mgdi.swisstopo.cloud') where data like '%http://geocat.lt.admin.ch%';
update metadata set data=replace(data, 'geocat.lt.admin.ch', 'geocat-int.apps.geocat-mgdi.swisstopo.cloud') where data like '%geocat.lt.admin.ch%';
update metadata set data=replace(data, 'che:CI_ResponsibleParty', 'che:CHE_CI_ResponsibleParty') where uuid = '845b01b9-3c59-44e0-86e8-c31f4d7b6551';
