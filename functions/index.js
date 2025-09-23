import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

admin.initializeApp();
const db = admin.firestore();

// When a user adds someone into collaborators, mirror the link and merge wishLists
export const onUserCollaboratorsWrite = functions.firestore
    .document("users/{uid}")
    .onWrite(async (change, context) => {
        const uid = context.params.uid;
        const after = change.after.exists ? change.after.data() : null;
        const before = change.before.exists ? change.before.data() : null;

        if (!after) return;

        const afterCollabs = new Set((after.collaborators || []).filter((x) => typeof x === "string"));
        const beforeCollabs = new Set((before?.collaborators || []).filter((x) => typeof x === "string"));

        // Find newly added collaborators
        const added = [...afterCollabs].filter((x) => !beforeCollabs.has(x));
        if (added.length === 0) return;

        await Promise.all(
            added.map(async (otherUid) => {
                if (otherUid === uid) return;
                const otherRef = db.collection("users").doc(otherUid);
                const selfRef = db.collection("users").doc(uid);

                // 1) Mirror collaborator link (make it symmetric)
                await otherRef.set({
                    collaborators: admin.firestore.FieldValue.arrayUnion(uid),
                }, { merge: true });

                // 2) Merge wishLists both ways (set union)
                const [selfSnap, otherSnap] = await Promise.all([selfRef.get(), otherRef.get()]);
                const selfData = selfSnap.data() || {};
                const otherData = otherSnap.data() || {};
                const selfWL = Array.isArray(selfData.wishList) ? selfData.wishList : [];
                const otherWL = Array.isArray(otherData.wishList) ? otherData.wishList : [];
                const byId = new Map();
                for (const it of selfWL) {
                    if (it && typeof it === 'object' && typeof it.id === 'string') byId.set(it.id, it);
                }
                for (const it of otherWL) {
                    if (it && typeof it === 'object' && typeof it.id === 'string' && !byId.has(it.id)) byId.set(it.id, it);
                }
                const union = Array.from(byId.values());

                await Promise.all([
                    selfRef.set({ wishList: union }, { merge: true }),
                    otherRef.set({ wishList: union }, { merge: true }),
                ]);
            })
        );
    });
