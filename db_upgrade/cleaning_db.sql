delete from schematroncriteria as c using schematron as s where s.id = c.group_schematronid and s.schemaname='iso19139.che';
delete from schematroncriteriagroup as g using schematron as s where s.id = g.schematronid and s.schemaname='iso19139.che';
delete from schematrondes as d using schematron as s where s.id = d.iddes and s.schemaname='iso19139.che';
delete from schematron where schemaname='iso19139.che';


delete from metadatafiledownloads where id not in (select id from metadatafiledownloads order by downloaddate desc limit 1000);
delete from metadatafileuploads where id not in (select id from metadatafileuploads order by uploaddate desc limit 1000);
drop table s_copy;
drop table countries_search;
drop table cswservercapabilitiesinfo;
drop table gt_pk_metadata;
alter table guf_userfeedbacks drop constraint fk_e9nt5jgp7gi12nvavaacs7bbr;
drop table guf_citation;
drop table metadatanotifications;
drop table metadatanotifiers;
drop table regionsdes;
drop table regions;
drop table serviceparameters;
drop table services;
drop table spatialindex;
drop table to_copy;
drop table to_recover;

update settings set value = 'iso19115-3.2018.che' where name = 'metadata/import/restrict';

delete from validation as v using metadata as m where m.id = v.metadataid and (m.istemplate='y' or m.istemplate='t');
delete from metadatacateg as c using metadata as m where m.id = c.metadataid and (m.istemplate='y' or m.istemplate='t');
delete from metadata where istemplate='y' or istemplate='t';
drop function update_geom_lastmodified;

-- update users set password='46e44386069f7cf0d4f2a420b9a2383a612f316e2024b0fe84052b0b96c479a23e8a0be8b90fb8c2'; -- set all passwords to admin

CREATE INDEX idx_linkstatus_linkid ON public.linkstatus USING btree (link);
alter table spg_sections drop constraint fk_lpi3x381t6kfsrn7wgmvy68qy;
alter table spg_sections drop column page_language;
alter table spg_sections drop column page_linktext;

alter table address ALTER COLUMN address TYPE varchar(255);
alter table address ALTER COLUMN city TYPE varchar(255);
alter table address ALTER COLUMN country TYPE varchar(255);
alter table address ALTER COLUMN state TYPE varchar(255);

drop function create_gt_pk_metadata;
drop sequence annotation_id_seq;

alter table files drop column _id;
alter table files drop column _content;
alter table files drop column _mimetype;

alter table guf_rating drop column category;

alter table files ALTER COLUMN content TYPE oid USING content::oid;