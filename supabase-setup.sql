-- ============================================================
-- 上班收钱模拟器 · 云同步建库脚本
-- 在 Supabase 控制台 → 左侧 SQL Editor → New query，
-- 把本文件全部内容粘贴进去，点 Run 运行一次即可。
-- ============================================================

-- 1) 数据表：每个同步码对应一份数据（JSON）
create table if not exists public.sync_store (
  sync_code  text primary key,
  payload    jsonb not null,
  updated_at timestamptz not null default now()
);

-- 2) 打开行级安全（默认拒绝一切直接访问）
alter table public.sync_store enable row level security;
-- 不创建任何 policy，意味着：拿到公开 key 也无法直接读写这张表，
-- 只能通过下面两个“需要同步码”的函数访问。

-- 3) 读取函数：必须提供正确的同步码才能拿到数据
create or replace function public.pull_data(p_code text)
returns jsonb
language sql
security definer
set search_path = public
as $$
  select payload from public.sync_store where sync_code = p_code;
$$;

-- 4) 写入函数：按同步码写入或更新
create or replace function public.push_data(p_code text, p_payload jsonb)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.sync_store (sync_code, payload, updated_at)
  values (p_code, p_payload, now())
  on conflict (sync_code)
  do update set payload = excluded.payload, updated_at = now();
end;
$$;

-- 5) 允许网页（匿名角色）调用这两个函数
grant execute on function public.pull_data(text)          to anon, authenticated;
grant execute on function public.push_data(text, jsonb)   to anon, authenticated;

-- 完成。安全模型：别人即使看到网页里的公开 key，
-- 没有你的“同步码”也读不到你的数据；同步码越长越安全（本应用自动生成 16 位随机码）。
