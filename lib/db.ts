import { neon } from "@neondatabase/serverless";

// Driver HTTP: cocok untuk serverless (tanpa koneksi persisten per fungsi)
export const sql = neon(process.env.DATABASE_URL!);
