-- Jalankan sekali di Neon SQL Editor

create table if not exists readings (
  id           bigserial primary key,
  created_at   timestamptz not null default now(),
  temperature  real,
  humidity     real,
  light_pct    int,
  distance_cm  real,
  relay_on     boolean not null,
  alarm        boolean not null default false
);
create index if not exists readings_created_at_idx on readings (created_at desc);

-- Satu baris saja: "keinginan" dari dashboard yang diambil ESP32 tiap kirim data
create table if not exists device_settings (
  id             int primary key default 1 check (id = 1),
  relay_on       boolean not null default false,
  auto_mode      boolean not null default true,
  temp_threshold real    not null default 30,
  alarm_armed    boolean not null default true,
  updated_at     timestamptz not null default now()
);
insert into device_settings (id) values (1) on conflict do nothing;

-- Mode standby, permintaan "ambil data sekarang", dan penanda perangkat terakhir terlihat.
-- Aman dijalankan ulang; wajib dijalankan jika tabel sudah dibuat dari versi sebelumnya.
alter table device_settings add column if not exists mode text not null default 'active'
  check (mode in ('active', 'standby'));
alter table device_settings add column if not exists sample_requested boolean not null default false;
alter table device_settings add column if not exists last_seen timestamptz;
