{ lib, ... }:
let
  mkMigaduDkim = zone: name: {
    inherit zone;
    name = "${name}._domainkey";
    type = "CNAME";
    records = [
      { value = "${name}.${zone}._domainkey.migadu.com."; }
    ];
  };
in
{
  mkMigadu_hcloud_zone_rrset = zone: hostedEmailVerify: {
    dkim_1 = mkMigaduDkim zone "key1";
    dkim_2 = mkMigaduDkim zone "key2";
    dkim_3 = mkMigaduDkim zone "key3";

    spf = {
      inherit zone;
      name = "@";
      type = "TXT";
      records = [
        {
          value = lib.tf.ref ''provider::hcloud::txt_record("v=spf1 include:spf.migadu.com -all")'';
        }
        {
          value = lib.tf.ref ''provider::hcloud::txt_record("hosted-email-verify=${hostedEmailVerify}")'';
        }
      ];
    };

    dmarc = {
      inherit zone;
      name = "_dmarc";
      type = "TXT";
      records = [
        {
          value = lib.tf.ref ''provider::hcloud::txt_record("v=DMARC1; p=quarantine;")'';
        }
      ];
    };

    mx = {
      inherit zone;
      name = "@";
      type = "MX";
      records = [
        { value = "10 aspmx1.migadu.com."; }
        { value = "20 aspmx2.migadu.com."; }
      ];
    };

    autoconfig = {
      inherit zone;
      name = "autoconfig";
      type = "CNAME";
      records = [ { value = "autoconfig.migadu.com."; } ];
    };

    autodiscover = {
      inherit zone;
      name = "_autodiscover._tcp";
      type = "SRV";
      records = [ { value = "0 1 443 autodiscover.migadu.com."; } ];
    };

    submissions = {
      inherit zone;
      name = "_submissions._tcp";
      type = "SRV";
      records = [ { value = "0 1 465 smtp.migadu.com."; } ];
    };

    imaps = {
      inherit zone;
      name = "_imaps._tcp";
      type = "SRV";
      records = [ { value = "0 1 993 imap.migadu.com."; } ];
    };

    pop3s = {
      inherit zone;
      name = "_pop3s._tcp";
      type = "SRV";
      records = [ { value = "0 1 995 pop.migadu.com."; } ];
    };
  };
}
