-- إنشاء جدول profiles
CREATE TABLE profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  email TEXT NOT NULL,
  full_name TEXT,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'active', 'suspended')),
  role TEXT DEFAULT 'user' CHECK (role IN ('user', 'admin')),
  plan TEXT DEFAULT 'free' CHECK (plan IN ('free', 'pro', 'unlimited')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- تفعيل Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- سياسة: المستخدم يرى بياناته فقط
CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

-- سياسة: Admin يرى الكل
CREATE POLICY "Admin can view all" ON profiles
  FOR ALL USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- سياسة: إدراج عند التسجيل
CREATE POLICY "Users can insert own profile" ON profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

-- إنشاء حساب Admin (غيّر الإيميل لإيميلك)
-- بعد تسجيل حسابك قم بتشغيل هذا:
-- UPDATE profiles SET role = 'admin', status = 'active' WHERE email = 'YOUR_ADMIN_EMAIL';
