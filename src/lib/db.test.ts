import { mkdtempSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';

let dir: string;
let db: typeof import('./db');

beforeAll(async () => {
	dir = mkdtempSync(join(tmpdir(), 'guestbook-'));
	process.env.DB_PATH = join(dir, 'nested', 'test.db');
	db = await import('./db');
});

afterAll(() => {
	rmSync(dir, { recursive: true, force: true });
});

describe('db', () => {
	it('starts empty', () => {
		expect(db.listMessages()).toEqual([]);
	});

	it('lists added messages newest first', () => {
		db.addMessage('Ada', 'First!');
		db.addMessage('Grace', 'Second');

		const messages = db.listMessages();
		expect(messages.map((m) => [m.name, m.message])).toEqual([
			['Grace', 'Second'],
			['Ada', 'First!'],
		]);
		expect(messages[0].created_at).toMatch(/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/);
	});
});
