export function getDb(): never {
  throw new Error("Database access is not configured for this Vercel deployment.");
}
