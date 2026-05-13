import express from 'express';
import { protect, authorizeRoles } from '../middleware/authMiddleware';
import { deleteResource } from '../controllers/resourceController';

const router = express.Router();

// Delete resource - Admin only
router.delete('/:resourceId', protect as any, authorizeRoles('admin'), deleteResource as any);

export default router;
