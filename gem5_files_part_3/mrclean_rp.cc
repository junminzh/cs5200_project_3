#include "mem/cache/replacement_policies/mrclean_rp.hh"

#include <cassert>
#include <memory>

#include "params/MrCleanRP.hh"
#include "sim/cur_tick.hh"

namespace gem5
{
namespace replacement_policy
{

MrClean::MrClean(const Params &p)
    : Base(p)
{
}

void
MrClean::invalidate(const std::shared_ptr<ReplacementData>& replacement_data)
{
    // Reset last touch timestamp and mark as clean
    std::shared_ptr<MrCleanReplData> casted_replacement_data =
        std::static_pointer_cast<MrCleanReplData>(replacement_data);
    casted_replacement_data->lastTouchTick = Tick(0);
    casted_replacement_data->isDirty = false;
}

void
MrClean::touch(const std::shared_ptr<ReplacementData>& replacement_data, const PacketPtr pkt)
{
    // Update last touch timestamp
    std::shared_ptr<MrCleanReplData> casted_replacement_data =
        std::static_pointer_cast<MrCleanReplData>(replacement_data);
    casted_replacement_data->lastTouchTick = curTick();

    // Update dirty status based on packet type
    // Mark as dirty if this is a write operation
    if (pkt && pkt->isWrite()) {
        casted_replacement_data->isDirty = true;
    }
}

void
MrClean::touch(const std::shared_ptr<ReplacementData>& replacement_data) const
{
    // Update last touch timestamp only
    std::static_pointer_cast<MrCleanReplData>(
        replacement_data)->lastTouchTick = curTick();
}

void
MrClean::reset(const std::shared_ptr<ReplacementData>& replacement_data,
               const PacketPtr pkt)
{
    // Set last touch timestamp and dirty status
    std::shared_ptr<MrCleanReplData> casted_replacement_data =
        std::static_pointer_cast<MrCleanReplData>(replacement_data);
    casted_replacement_data->lastTouchTick = curTick();

    // Mark as dirty if this is a write operation, clean otherwise
    if (pkt && pkt->isWrite()) {
        casted_replacement_data->isDirty = true;
    } else {
        casted_replacement_data->isDirty = false;
    }
}

void
MrClean::reset(const std::shared_ptr<ReplacementData>& replacement_data) const
{
    // Set last touch timestamp and mark as clean by default
    std::shared_ptr<MrCleanReplData> casted_replacement_data =
        std::static_pointer_cast<MrCleanReplData>(replacement_data);
    casted_replacement_data->lastTouchTick = curTick();
    casted_replacement_data->isDirty = false;
}

ReplaceableEntry*
MrClean::getVictim(const ReplacementCandidates& candidates) const
{
    // There must be at least one replacement candidate
    assert(candidates.size() > 0);

    // Separate dirty and clean candidates
    ReplaceableEntry* dirtyVictim = nullptr;
    ReplaceableEntry* cleanVictim = nullptr;

    Tick oldestDirtyTick = std::numeric_limits<Tick>::max();
    Tick oldestCleanTick = std::numeric_limits<Tick>::max();

    // Find the LRU dirty and clean candidates
    for (const auto& candidate : candidates) {
        std::shared_ptr<MrCleanReplData> casted_data =
            std::static_pointer_cast<MrCleanReplData>(
                candidate->replacementData);

        if (casted_data->isDirty) {
            // This is a dirty block
            if (casted_data->lastTouchTick < oldestDirtyTick) {
                oldestDirtyTick = casted_data->lastTouchTick;
                dirtyVictim = candidate;
            }
        } else {
            // This is a clean block
            if (casted_data->lastTouchTick < oldestCleanTick) {
                oldestCleanTick = casted_data->lastTouchTick;
                cleanVictim = candidate;
            }
        }
    }

    // Prefer dirty blocks over clean blocks
    if (dirtyVictim != nullptr) {
        return dirtyVictim;
    } else {
        // No dirty blocks available, return LRU clean block
        assert(cleanVictim != nullptr);
        return cleanVictim;
    }
}

std::shared_ptr<ReplacementData>
MrClean::instantiateEntry()
{
    return std::shared_ptr<ReplacementData>(new MrCleanReplData());
}

} // namespace replacement_policy
} // namespace gem5