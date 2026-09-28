import { mkdirSync } from 'node:fs';
import { dirname } from 'node:path';
import { DatabaseSync } from 'node:sqlite';

export interface Message {
	id: number;
	name: string;
	message: string;
	created_at: string;
}

const dbPath = process.env.DB_PATH ?? 'data/guestbook.db';

mkdirSync(dirname(dbPath), { recursive: true });

const db = new DatabaseSync(dbPath);

db.exec(`
	CREATE TABLE IF NOT EXISTS messages (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		name TEXT NOT NULL,
		message TEXT NOT NULL,
		created_at TEXT NOT NULL DEFAULT (datetime('now'))
	)
`);

const insert = db.prepare('INSERT INTO messages (name, message) VALUES (?, ?)');
const selectAll = db.prepare('SELECT id, name, message, created_at FROM messages ORDER BY id DESC');

export function addMessage(name: string, message: string) {
	insert.run(name, message);
}

export function listMessages() {
	return selectAll.all() as unknown as Message[];
}
